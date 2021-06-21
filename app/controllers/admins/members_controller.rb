module Admins
  class MembersController < ApplicationController

    api :GET, 'api/members', "Only super_admin, admin, startup_admin can see list of members that depends on current_user access level"
    param :page, Integer, desc: "Page for members iteration (10 items per page)"

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

    === Success response body
    {
      "current_page": 1,
      "total_pages": 2,
      "members": [
        {
          "id": 5,
          "email": "emily@gmail.com",
          "created_at": "2021-04-09T18:53:43.416Z",
          "updated_at": "2021-04-09T19:04:59.578Z",
          "first_name": "Emily",
          "last_name": "Smith",
          "accelerator_id": 1,
          "startup_id": 3,
          "phone_number": "121241241",
          "email_notification": true,
          "startup": {
            "id": 3,
            "name": "NMH",
            "accelerator_id": 1,
            "created_at": "2021-04-09T19:04:59.551Z",
            "updated_at": "2021-04-09T19:04:59.551Z"
          }
        },
        ...
      ]
    }

    DESC

    def index
      authorize current_user, policy_class: MemberPolicy

      @members = policy_scope(User).members.with_name.for_accelerator(user_accelerator_id).page(page_params)

      render json: {
        current_page: @members.current_page,
        total_pages: @members.total_pages,
        members: @members.as_json(include: :startup)
      }
    end

    private

      def page_params
        params[:page] || 1
      end
  end
end
