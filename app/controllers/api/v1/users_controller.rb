# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: %i[ show update destroy ]
      before_action :authorize_resource, only: %i[show update destroy]

      # GET /users
      # GET /users.json
      def index
        @users = policy_scope(User.all)
      end

      # GET /users/1
      # GET /users/1.json
      def show
      end

      # POST /users
      # POST /users.json
      def create
        @user = authorize(User.new(user_params))

        if @user.save
          render :show, status: :created, location: api_v1_user_path(@user)
        else
          render "common/model_errors",
            locals: { instance: @user },
            status: :unprocessable_entity
        end
      end

      # PATCH/PUT /users/1
      # PATCH/PUT /users/1.json
      def update
        @user.assign_attributes(user_params)
        if @user.save
          render :show, status: :ok, location: api_v1_user_path(@user)
        else
          render "common/model_errors",
            locals: { instance: @user },
            status: :unprocessable_entity
        end
      end

      # DELETE /users/1
      # DELETE /users/1.json
      def destroy
        byebug
        @user.destroy
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_user
          @user = User.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def user_params
          params.require(:user).permit(
            :email, :password, :password_confirmation, :first_name, :last_name)
        end
    end
  end
end
