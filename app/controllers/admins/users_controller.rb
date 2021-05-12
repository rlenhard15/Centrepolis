module Admins
  class UsersController < ApplicationController

    api :POST, 'api/users', 'Only SuperAdmin, Admin, StartupAdmin can create account for certain type of user and invite his on email'
    param :user, Hash, required: true do
      param :email, String, desc: 'Unique email for user', required: true
    end

    description <<-DESC

      === Request headers
        SuperAdmin can only invite Admin and Member
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
      @admin = Admin.new(
        user_params.merge({
          accelerator_id: user_accelerator_id,
          password: user_random_password
        })
      )
      authorize @admin

      if @admin.save
        render json: @admin, status: :created
      else
        render json: @admin.errors, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:email)
    end
  end
end
