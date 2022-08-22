# frozen_string_literal: true

require "jwt"

# A manager class for handling JWT tokens.  This sets a bunch of sane defaults
# and uses config values and encrypted credentials for configuration (see the
# initalizer).  It also handles a revocation list, to emulate a "user logout"
# action.
class JwtManager
  @revoked_list = {}

  def self.hmac_secret
    env = Rails.env
    key = Rails.application
      .credentials[env.to_sym]
      &.fetch(:jwt)
      &.fetch(:hmac_secret)
    if key.blank?
      raise ArgumentError,
        "Set the jwt.hmac_secret for Rails env #{env} " +
        "(i.e. openssl rand -hex 256, and store it Rails secure credentials)"
    end
    key
  end

  # Encode a payload (hash) in a JWT token.  Use config values to set
  # nbf (not before) and exp (expiration) values.
  # Values for iss (issuer) and aud (audience) are not included by default.
  # Add them to the payload hash if desired.
  # +payload+ is a hash of attributes to include.  The following attributes are
  # included automatically:
  #   +iat+ time of creation
  #   +nbf+ "not before" time
  #   +exp+ expiration time
  #   +jti+ unique id
  def self.encode(payload)
    clean_revoked_list if rand < 0.1 # clean with a 10% probability
    pl = payload.reverse_merge(nbf.merge(exp, iat, jti))
    JWT.encode(pl, hmac_secret, algorithm)
  end

  def self.decode(token)
    raise JWT::RevokedToken if revoked?(token)
    JWT.decode token, hmac_secret, true, { algorithm: }
  end

  # Add the revocation hash for this +token+ to the revoked list.
  # Note that the jti (unique id) is required for the revoke list to work.
  # Without it, two tokens created in the same second might have the same
  # hash.
  def self.revoke(token)
    rh = revocation_hash(token)
    return if @revoked_list[rh]
    exp = payload(token)["exp"]
    @revoked_list[rh] = exp.to_i
  end

  def self.revoked?(token)
    !@revoked_list[revocation_hash(token)].nil?
  end

  private
    def self.payload(token)
      Base64.decode64(token.split(".")[1]).to_json
    end

    def self.revocation_hash(token)
      Digest::SHA256.hexdigest(token)
    end

    def self.clean_revoked_list
      @revoked_list.each_pair do |k, v|
        @revoked_list.delete(k) if v.to_i > Time.now.to_i
      end
    end

    def self.algorithm
      Rails.configuration.x.jwt.cryptographic_algorithm
    end

    # Time of creation in seconds.
    def self.iat
      iat = Time.now.to_i
      { iat: }
    end

    # "Not Before" time in seconds.
    def self.nbf
      nbf = Time.now.to_i - 3600
      { nbf: }
    end

    # Expiration time in seconds.
    def self.exp
      exp = Time.now.to_i + Rails.configuration.x.jwt.ttl
      { exp: }
    end

    # Unique identifier.
    def self.jti
      { jti: SecureRandom.uuid }
    end
end

# Extend JWT with a new error:
module JWT
  class RevokedToken < DecodeError; end
end
