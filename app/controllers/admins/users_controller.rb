module Admins
  class UsersController < ApplicationController
    before_action :set_profile, only: :profile
    before_action :set_startup, only: :index

    api :GET, 'api/users/profile', "Request for current_user profile"

    description <<-DESC

    === Request headers
    SuperAdmin or Admin or StartupAdmin or Member can perform this action
      SuperAdmin   - has no additional info about startup
      Admin        - has additional info(startups array) about startups were created by the current admin
      StartupAdmin - has additional info (only one startup) about startup is belonged to current startup_admin
      Member       - has additional info (only one startup) about startup is belonged to current member
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
    Accelerator-Id - integer - required
      Example of Accelerator-Id header : 1

    === Success response body for StartupAdmin or Member
    {
      "id": 3,
      "email": "member@gmail.com",
      "created_at": "2021-04-09T18:51:32.967Z",
      "updated_at": "2021-04-09T19:04:59.508Z",
      "first_name": "Eva",
      "last_name": "Evans",
      "accelerator_id": 1,
      "startup_id": 1,
      "startup": {
        "id": 1,
        "name": "MSI",
        "accelerator_id": 1,
        "created_at": "2021-04-09T19:04:59.356Z",
        "updated_at": "2021-05-24T14:08:22.089Z"
      }
    }

    === Success response body for Admin
    {
      "id": 1,
      "email": "admin@gmail.com",
      "created_at": "2021-05-24T13:23:02.316Z",
      "updated_at": "2021-05-24T13:24:33.062Z",
      "first_name": "Boris",
      "last_name": "Klochko",
      "accelerator_id": 1,
      "startup_id": null,
      "startups": [
        {
          "id": 1,
          "name": "MSI",
          "accelerator_id": 1,
          "created_at": "2021-04-09T19:04:59.356Z",
          "updated_at": "2021-05-24T14:08:22.089Z"
        },
        ...
      ]
    }

    === Success response body for SuperAdmin
    {
      "id": 14,
      "email": "super_admin@gmail.com",
      "created_at": "2021-04-12T12:04:39.943Z",
      "updated_at": "2021-04-12T12:04:39.943Z",
      "first_name": "Samuel",
      "last_name": "Ramirez",
      "accelerator_id": null,
      "startup_id": null
    }


    DESC

    def profile
      render json: @profile
    end

    api :GET, 'api/users', "Only super_admin, admin, startup_admin can see list of users that depends on current_user access level"

    param :startup_id, Integer, desc: "id of a startup, required if current_user is SuperAdmin or Admin", required: true
    param :search, String, desc: "String for search by first_name or last_name of users"
    param :page, Integer, desc: "Page for users iteration (5 items per page)"


    description <<-DESC

    === Request headers
      Only SuperAdmin, Admin, StartupAdmin can perform this action
        SuperAdmin   - all users of the accelerator;
        Admin        - all users of startups that were created by the admin;
        StartupAdmin - all users of the startup of StartupAdmin;

        Authentication - string - required
          Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
        Accelerator-Id - integer - required
            Example of Accelerator-Id header : 1

    === Success response body
    {
      "current_page": 1,
      "total_pages": 2,
      "users": [
        {
          "id": 22,
          "email": "user@gmail.com",
          "created_at": "2021-05-05T13:35:47.967Z",
          "updated_at": "2021-05-05T13:37:19.248Z",
          "first_name": "Michiel",
          "last_name": "Pack",
          "accelerator_id": 1,
          "startup_id": 8
        },
        ...
      ]
    }

    DESC

    def index
      authorize current_user, policy_class: UserPolicy

      @users = policy_scope(User).for_startup(@startup_id).search_by(search_params).page(page_params)

      render json: {
        current_page: @users.current_page,
        total_pages: @users.total_pages,
        users: @users
      }
    end

    api :POST, 'api/users', 'Only SuperAdmin, Admin, StartupAdmin can create account for certain type of user and invite his on email'
    param :user, Hash, required: true do
      param :email, String, desc: 'Unique email for user', required: true
      param :type, String, desc: 'Type for user (valid values are Admin, StartupAdmin or Member)', required: true
      param :startup_id, Integer, desc: "Id of a startup (required only for SuperAdmin and Admin)", required: true
    end

    description <<-DESC

      === Request headers
        SuperAdmin can only invite Admin and Member
        Admin can only invite StartupAdmin and Member
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

    api :PUT, 'api/users/change_password'
    param :user, Hash, required: true do
      param :current_password, String, desc: 'Current password of user', required: true
      param :password, String, desc: 'New password', required: true
    end

    description <<-DESC
      === Request headers
        SuperAdmin, Admin, StartupAdmin or Member can perform this action
          Authentication - string - required
            Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
          Accelerator-Id - integer - required
            Example of Accelerator-Id header : 1

      === Success response body
      {
        "id": 14,
        "email": "member@gmail.com",
        "created_at": "2021-04-12T12:04:39.943Z",
        "updated_at": "2021-06-03T18:49:02.471Z",
        "first_name": "Samuel",
        "last_name": "Ramirez",
        "accelerator_id": 1,
        "startup_id": 1
      }

    DESC

    def change_password
      if current_user.update_with_password(update_password_params)
        render json: current_user
      else
        render json: current_user.errors, status: :bad_request
      end
    end

    private

    def update_password_params
      params.require(:user).permit(:current_password, :password)
    end

    def search_params
      params[:search]&.downcase  || ''
    end

    def page_params
      params[:page] || 1
    end

    def set_startup
      raise Pundit::NotAuthorizedError unless @startup_id = startup_id_for_current_user
    end

    def set_profile
      @profile = UsersService::UserProfile.call(current_user)
    end

    def user_params
      params.require(:user).permit(:email, :startup_id, :type)
    end
  end
end
