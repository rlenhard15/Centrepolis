module Admins
  class MembersController < ApplicationController

    api :GET, 'api/members', "Only super_admin, admin, startup_admin can see list of members that depends on current_user access level"
    description <<-DESC

    === Request headers
      Only SuperAdmin, Admin, startup_admin can perform this action
        SuperAdmin   - all members of the accelerator;
        Admin        - all members of startups that were created by the admin;
        StartupAdmin - all members of the startup of StartupAdmin;

        Authentication - string - required
          Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
        Accelerator-Id - integer - required
            Example of Accelerator-Id header : 1

    === Params
      Params are absent

    === Success response body
    [
      {
        "id": 5,
        "email": "user@gmail.com",
        "created_at": "2021-04-06T10:48:34.453Z",
        "updated_at": "2021-04-06T10:48:45.909Z",
        "first_name": "Emily",
        "last_name": "Smith",
        "startup_id": 1,
        "accelerator_id": 1,
        "assessments_risk_list": [
          {
            "assessment": "CRL (Commercial Readiness Level)",
            "risk_value": "3.92156862745098"
          },
          ...
        ],
        "startup": {
          "id": 1,
          "name": "Example",
          "accelerator_id": 1,
          "created_at": "2021-04-05T19:58:08.921Z",
          "updated_at": "2021-04-06T10:55:04.576Z",
          "created_by": 2
        }
      },
      ...
    ]

    DESC
    def index
      authorize current_user, policy_class: UserPolicy

      render json: policy_scope(User).members.as_json(include: :startup, methods: [:assessments_risk_list])
    end

    api :POST, 'api/customers', 'Only admin can create account for customer and invite his on email'
    param :user, Hash, required: true do
      param :email, String, desc: 'Unique email for customer', required: true
      param :company_name, String, desc: 'Unique company name for customer', required: true
      param :accelerator_id, String, desc: 'Accelerator ID', required: true
    end

    description <<-DESC

      === Request headers
        Only admin can perform this action
          Authentication - string - required
            Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

      === Success response body
      {
        "user": {
          "id": 49,
          "email": "customer_example@gmail.com",
          "created_at": "2020-03-02T12:43:28.691Z",
          "updated_at": "2020-03-02T12:43:28.691Z",
          "first_name": null,
          "last_name": null,
          "company_name": "MSI",
          "created_by": 1
        }
      }
    DESC

    def create
      @member = Member.new(
        user_params.merge({
          password: member_random_password
        })
      )
      authorize @member

      if @member.save
        render json: @member, status: :created
      else
        render json: @member.errors, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.require(:member).permit(:email, :accelerator_id, :startup_id)
    end

    def member_random_password
      Devise.friendly_token.first(8)
    end
  end
end
