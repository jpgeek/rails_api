require 'jwt'

module LocalJwt
  class Coder
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

    def self.algorithm
      Rails.configuration.x.jwt.cryptographic_algorithm
    end

    def self.encode(payload)
      JWT.encode(payload, hmac_secret, algorithm)
    end

    def self.decode(token)
      JWT.decode token, hmac_secret, true, { algorithm: algorithm }
    end
  end
end
