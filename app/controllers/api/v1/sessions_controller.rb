module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authenticate, only: :create

      def create
        user = User.find_by(email: params[:email])
          &.authenticate(params[:password])
        unless user
          render_error_payload(:authentication_failed)
          return
        end
        jwt = JwtManager.encode({user_id: user.id})
        render json: { authentication: { jwt: jwt } }
      end

      def logout
        JwtManager.revoke(jwt_token)
      end
    end
  end
end
