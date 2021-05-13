module Admins
  class UsersController < ApplicationController

    api :POST, 'api/users', 'Only SuperAdmin, Admin, StartupAdmin can create account for certain type of user and invite his on email'
    param :user, Hash, required: true do
      param :email, String, desc: 'Unique email for user', required: true
      param :type, String, desc: 'Type for user (valid values are Admin, StartupAdmin or Member)', required: true
      param :startup_id, Integer, desc: "Id of a startup (required only for SuperAdmin and Admin)", required: true
    end

    description <<-DESC

      === Request headers
        SuperAdmin can only invite Admin and Member
        Admin can only invite SuperAdmin and Member
        StartupAdmin can only invite Member
          Authentication - string - required
            Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
          Accelerator-Id - integer - required
            Example of Accelerator-Id header : 1

      === Success response body
      {
        "id": 18,
        "email": "admin@gmail.com",
        "created_at": "2021-04-28T14:21:53.443Z",
        "updated_at": "2021-04-28T14:21:53.443Z",
        "first_name": null,
        "last_name": null,
        "accelerator_id": 1,
        "startup_id": null
      }

    DESC

    def create
      @user = UsersService::CreateUser.call(user_params, user_accelerator_id, current_user)

      authorize @user if @user

      if @user.save
        render json: @user, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :startup_id, :type)
    end
  end
end
