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
        "phone_number": "(186)285-7925",
        "email_notification": true,
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
      authorize current_user, policy_class: MemberPolicy

      render json: policy_scope(User).members.with_name.for_accelerator(user_accelerator_id).as_json(include: :startup)
    end
  end
end
