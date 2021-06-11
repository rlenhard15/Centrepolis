class StartupsController < ApplicationController
  before_action :set_startup, only: [:show, :update, :destroy]

  api :GET, 'api/startups', "List of startups"
  param :page, Integer, desc: "Page for startups iteration (10 items per page)"

  description <<-DESC

  === Request headers
    SuperAdmin or Admin can perform this action
      SuperAdmin   - all startups of the accelerator;
      Admin        - all startups assigned to him;
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
    Accelerator-Id - integer - required
      Example of Accelerator-Id header : 1

  === Success response body
  {
    "current_page": 1,
    "total_pages": 2,
    "startups": [
      {
        "id": 1,
        "name": "MSI",
        "accelerator_id": 1,
        "created_at": "2021-04-09T19:04:59.356Z",
        "updated_at": "2021-04-09T19:04:59.356Z",
        "assessments_risk_list": [
          {
            "assessment": "CRL (Commercial Readiness Level)",
            "risk_value": "3.92156862745098"
          },
          ...
        ],
        "admins": [
          {
            "id": 1,
            "email": "admin@gmail.com",
            "created_at": "2021-05-24T13:23:02.316Z",
            "updated_at": "2021-06-07T17:28:49.503Z",
            "first_name": "Mark",
            "last_name": "Snider",
            "accelerator_id": 1,
            "startup_id": null,
            "phone_number": null,
            "email_notification": true
          },
          ...
        ],
        "members": [
          {
            "id": 3,
            "email": "eva@gmail.com",
            "created_at": "2021-04-09T18:51:32.967Z",
            "updated_at": "2021-04-09T19:04:59.508Z",
            "first_name": "Eva",
            "last_name": "Evans",
            "accelerator_id": 1,
            "startup_id": 1,
            "email_notification": true
          },
          ...
        ],
        "startup_admins": [
          {
            "id": 8,
            "email": "startup_admin@gmail.com",
            "created_at": "2021-04-12T08:55:37.469Z",
            "updated_at": "2021-04-12T08:55:37.469Z",
            "first_name": "Nikole",
            "last_name": "Smith",
            "accelerator_id": 1,
            "startup_id": 1,
            "email_notification": true
          },
          ...
        ]
      },
      ...
    ]
  }

  DESC

  def index
    authorize current_user, policy_class: StartupPolicy

    @startups = policy_scope(Startup).for_accelerator(user_accelerator_id).page(page_params)

    render json: {
      current_page: @startups.current_page,
      total_pages: @startups.total_pages,
      startups: @startups.as_json(methods: [:assessments_risk_list, :members, :startup_admins, :admins])
    }
  end

  api :POST, 'api/startups', "Create new startup and assign its to the specific admins"

  param :startup, Hash, required: true do
    param :name, String, desc: 'Name of startup', required: true
    param :admins_startups_attributes, Array, desc: 'required if current_user is SuperAdmin', required: true do
      param :admin_id, Integer, desc: 'Id of admin who have access to the startup', required: true
    end
  end

  description <<-DESC

  === Request headers
    Only SuperAdmin or Admin can perform this action
      Authentication - string - required
        Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
      Accelerator-Id - integer - required
        Example of Accelerator-Id header : 1

  === Success response body
  {
    "id": 12,
    "name": "Company name",
    "accelerator_id": 1,
    "created_at": "2021-04-16T09:53:05.871Z",
    "updated_at": "2021-04-16T09:53:05.871Z",
    "admins": [
      {
        "id": 2,
        "email": "admin@gmail.com",
        "created_at": "2021-04-09T18:49:34.985Z",
        "updated_at": "2021-04-09T18:49:34.985Z",
        "first_name": "Admin",
        "last_name": "Adm",
        "accelerator_id": 1,
        "startup_id": null
      },
      ...
    ]
  }

  DESC

  def create
    startup_params_create = startup_admins_params
    @startup = Startup.new(startup_params_create.merge({accelerator_id: user_accelerator_id}))

    authorize @startup

    if @startup.save
      StartupsService::SendEmailStartupCreated.call(@startup, current_user)
      StartupsService::SendEmailToAssignedAdmins.call(startup_params_create, @startup, current_user) if startup_params_create[:admins_startups_attributes]

      render json: @startup.as_json(methods: :admins), status: :created
    else
      render json: @startup.errors, status: :unprocessable_entity
    end
  end

  api :GET, 'api/startups/:id', "Request for a certain startup"
  param :id, Integer, desc: "id of startup",  required: true

  description <<-DESC

  === Request headers
    SuperAdmin or Admin or StartupAdmin or Member can perform this action
      SuperAdmin   - can request any startup of any accelerator;
      Admin        - can request startups that were created by the admin;
      StartupAdmin - can see only a startup of the StartupAdmin;
      Member       - can see only a startup of the Member
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
    Accelerator-Id - integer - required
      Example of Accelerator-Id header : 1

  === Success response body for StartupAdmin or Member
  {
    "id": 1,
    "name": "MSI",
    "accelerator_id": 1,
    "created_at": "2021-04-09T19:04:59.356Z",
    "updated_at": "2021-05-24T14:08:22.089Z",
    "assessments_risk_list": [
        {
            "assessment": "CRL (Commercial Readiness Level)",
            "risk_value": "3.92156862745098"
        },
        {
            "assessment": "MRL",
            "risk_value": "5.12820512820513"
        },
        {
            "assessment": "TRL",
            "risk_value": "100.0"
        }
    ],
    "members": [
      {
        "id": 12,
        "email": "member@gmail.com",
        "created_at": "2021-04-12T09:26:34.286Z",
        "updated_at": "2021-04-12T09:26:45.599Z",
        "first_name": "Nicole",
        "last_name": "Smith",
        "accelerator_id": 1,
        "startup_id": 1,
        "tasks_number": 5,
        "last_visit": "2021-05-31T11:26:34.768Z",
        "user_type": "Member",
        "email_notification": true
      },
      ...
    ],
    "startup_admins": [
      {
        "id": 20,
        "email": "startup_admin@gmail.com",
        "created_at": "2021-05-03T09:09:11.536Z",
        "updated_at": "2021-05-03T09:10:44.003Z",
        "first_name": "Maria",
        "last_name": "Lee",
        "accelerator_id": 1,
        "startup_id": 1,
        "tasks_number": 3,
        "last_visit": "2021-05-31T11:26:34.768Z",
        "user_type": "StartupAdmin",
        "email_notification": true
      },
      ...
    ]
  }

  === Success response body for StartupAdmin or Member
  {
    "id": 1,
    "name": "MSI",
    "accelerator_id": 1,
    "created_at": "2021-04-09T19:04:59.356Z",
    "updated_at": "2021-05-24T14:08:22.089Z",
    "assessments_risk_list": [
        {
            "assessment": "CRL (Commercial Readiness Level)",
            "risk_value": "3.92156862745098"
        },
        {
            "assessment": "MRL",
            "risk_value": "5.12820512820513"
        },
        {
            "assessment": "TRL",
            "risk_value": "100.0"
        }
    ],
    "admins": [
      {
        "id": 1,
        "email": "admin@gmail.com",
        "created_at": "2021-05-24T13:23:02.316Z",
        "updated_at": "2021-06-07T17:28:49.503Z",
        "first_name": null,
        "last_name": null,
        "accelerator_id": 1,
        "startup_id": null,
        "phone_number": null,
        "email_notification": true
        }
    ],
    "members": [
      {
        "id": 12,
        "email": "member@gmail.com",
        "created_at": "2021-04-12T09:26:34.286Z",
        "updated_at": "2021-04-12T09:26:45.599Z",
        "first_name": "Nicole",
        "last_name": "Smith",
        "accelerator_id": 1,
        "startup_id": 1,
        "tasks_number": 5,
        "last_visit": "2021-05-31T11:26:34.768Z",
        "user_type": "Member",
        "email_notification": true
      },
      ...
    ],
    "startup_admins": [
      {
        "id": 20,
        "email": "startup_admin@gmail.com",
        "created_at": "2021-05-03T09:09:11.536Z",
        "updated_at": "2021-05-03T09:10:44.003Z",
        "first_name": "Maria",
        "last_name": "Lee",
        "accelerator_id": 1,
        "startup_id": 1,
        "tasks_number": 3,
        "last_visit": "2021-05-31T11:26:34.768Z",
        "user_type": "StartupAdmin",
        "email_notification": true
      },
      ...
    ]
  }


  DESC

  def show
    if current_user.super_admin? || current_user.admin?
      render json: @startup.as_json(methods: [:assessments_risk_list, :admins], include: {
        members: {methods: [:tasks_number, :last_visit, :user_type]},
        startup_admins: {methods: [:tasks_number, :last_visit, :user_type]}
      })
    else
      render json: @startup.as_json(methods: :assessments_risk_list, include: {
        members: {methods: [:tasks_number, :last_visit, :user_type]},
        startup_admins: {methods: [:tasks_number, :last_visit, :user_type]}
      })
    end
  end

  api :PUT, 'api/startups/:id', "Update info of a certain startup and assign admins to the startups"
  param :id, Integer, desc: "id of startup",  required: true

  param :startup, Hash, required: true do
    param :name, String, desc: "Name of the startup", required: false
    param :admins_startups_attributes, Array, required: false do
      param :admin_id, Integer, desc: 'Id of admins who will have access the startup (required only if current_user is SuperAdmin want to update startup)', required: true
    end
  end

  description <<-DESC

  === Request headers
    SuperAdmin or Admin or StartupAdmin can perform this action
      SuperAdmin   - can update name and add new admins to the startup;
      Admin        - can update name;
      StartupAdmin - can update name;
      Authentication - string - required
        Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
      Accelerator-Id - integer - required
        Example of Accelerator-Id header : 1

  === Success response body(admins shows only for SuperAdmin or Admin)
  {
    "id": 1,
    "name": "New name",
    "accelerator_id": 1,
    "created_at": "2021-04-09T19:04:59.356Z",
    "updated_at": "2021-05-24T12:59:11.745Z",
    "admins": [
      {
        "id": 1,
        "email": "admin@gmail.com",
        "created_at": "2021-04-09T18:49:05.376Z",
        "updated_at": "2021-04-09T18:49:05.376Z",
        "first_name": "Admin",
        "last_name": "Adm",
        "accelerator_id": 1,
        "startup_id": null,
        "email_notification": true
      }
    ]
  }

  DESC

  def update
    startup_params_update = startup_admins_params

    if @startup.update(startup_params_update)
      if current_user.super_admin? || current_user.admin?
        StartupsService::SendEmailToAssignedAdmins.call(startup_params_update, @startup, current_user) if startup_params_update[:admins_startups_attributes]
        render json: @startup.as_json(methods: :admins)
      else
        render json: @startup
      end

    else
      render json: @startup.errors, status: :unprocessable_entity
    end
  end

  api :PUT, 'api/startups/:id', "Update info of a certain startup and assign admins to the startups"
  param :id, Integer, desc: "id of startup",  required: true

  param :startup, Hash, required: true do
    param :name, String, desc: "Name of the startup", required: false
    param :admins_startups_attributes, Array, required: false do
      param :admin_id, Integer, desc: 'Id of admins who will have access the startup (required only if current_user is SuperAdmin want to update startup)', required: true
    end
  end

  description <<-DESC

  === Request headers
    SuperAdmin or Admin perform this action
      SuperAdmin   - can delete all startups of the current accelerator;
      Admin        - can delete only th startups were created by the admin;
      Authentication - string - required
        Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
      Accelerator-Id - integer - required
        Example of Accelerator-Id header : 1

  === Success response body
  {
    "message": "Successfully destroyed"
  }

  DESC

  def destroy
    if @startup.destroy
      render json: {
        message: 'Successfully destroyed'
      }, status: :ok
    else
      render json: @startup.errors, status: :unprocessable_entity
    end
  end

  private

  def set_startup
    raise Pundit::NotAuthorizedError unless @startup = (policy_scope(Startup).where(id: params[:id], accelerator_id: user_accelerator_id)).first

    authorize @startup
  end

  def page_params
    params[:page]
  end

  def startup_admins_params
    if startup_params[:admins_startups_attributes] || current_user.admin?
      admins_ids_for_startup = startup_params[:admins_startups_attributes].map { |admin| admin[:admin_id] } if current_user.super_admin?
      if !@startup
        @admins = current_user.super_admin? ? policy_scope(User).where({id: admins_ids_for_startup || 0, type: "Admin", accelerator_id: user_accelerator_id}) : [current_user]
      else
        @admins = current_user.super_admin? ? policy_scope(User).where({id: admins_ids_for_startup, type: "Admin", accelerator_id: user_accelerator_id}).where.not(id: @startup.admin_ids) : nil
      end

      validated_admins_ids_hash = []

      @admins&.each do |admin|
        validated_admins_ids_hash.push({admin_id: admin&.id})
      end
      startup_params_hash = startup_params.to_h
      startup_params_hash[:admins_startups_attributes] = validated_admins_ids_hash
      return startup_params_hash
    end
    return startup_params
  end

  def startup_params
    params.require(:startup).permit(:name, admins_startups_attributes: [ :admin_id ])
  end
end
