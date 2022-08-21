# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate

  def authenticate 
    byebug
    return @current_user unless @current_user.blank?
    if jwt_token.blank?
      render_error_payload(:token_not_provided)
      return
    end
    begin
      decoded_token = decoded_jwt_token
      @current_user = User.find(decoded_token[0]['user_id'])
    rescue JWT::RevokedToken
      render_error_payload(:token_revoked)
    rescue JWT::ExpiredSignature
      render_error_payload(:token_expired)
    rescue JWT::DecodeError
      render_error_payload(:token_decode_error)
    rescue ActiveRecord::RecordNotFound
      render_error_payload(:user_not_found)
    end
  end

  def current_user
    @current_user
  end

  protected

    def render_error_payload(identifier)
      ep = ErrorPayload.new(identifier)
      render json: ep, status: ep.status_code
    end

    def decoded_jwt_token
      token = jwt_token
      return nil if token.blank?
      JwtManager.decode(token)
    end

    def jwt_token
      # Look for the Authorization header, Beaerer schema.
      # https://jwt.io/introduction/
      # ex:
      #   Authorization: Bearer <token>
      header = request.headers['Authorization'] || ''
      header&.split(' ')&.last&.strip if header
    end
end
