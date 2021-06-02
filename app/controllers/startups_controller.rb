class StartupsController < ApplicationController
  before_action :set_startup, only: [:show, :update]

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
        ]
        "members": [
          {
            "id": 3,
            "email": "eva@gmail.com",
            "created_at": "2021-04-09T18:51:32.967Z",
            "updated_at": "2021-04-09T19:04:59.508Z",
            "first_name": "Eva",
            "last_name": "Evans",
            "accelerator_id": 1,
            "startup_id": 1
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
            "startup_id": 1
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

    @startups = policy_scope(Startup).page(page_params)

    render json: {
      current_page: @startups.current_page,
      total_pages: @startups.total_pages,
      startups: @startups.as_json(methods: [:assessments_risk_list, :members, :startup_admins])
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
    "admins_for_startup": [
      {
        "id": 2,
        "email": "admin@gmail.com",
        "created_at": "2021-04-09T18:49:34.985Z",
        "updated_at": "2021-04-09T18:49:34.985Z",
        "first_name": "Admin2",
        "last_name": "Adm2",
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

      render json: @startup.as_json(methods: :admins_for_startup), status: :created
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

  === Success response body
  {
    "id": 2,
    "name": "Xiomi",
    "accelerator_id": 1,
    "created_at": "2021-04-09T19:04:59.513Z",
    "updated_at": "2021-04-09T19:04:59.513Z",
    "assessments_risk_list": [
      {
        "assessment": "CRL (Commercial Readiness Level)",
        "risk_value": "5.88235294117647"
      },
      ...
    ],
    "members": [
      {
        "id": 4,
        "email": "member@gmail.com",
        "created_at": "2021-04-09T18:52:30.042Z",
        "updated_at": "2021-04-09T19:04:59.546Z",
        "first_name": "Emily",
        "last_name": "Pack",
        "accelerator_id": 1,
        "startup_id": 2
      },
      ...
    ],
    "startup_admins": [
      {
        "id": 9,
        "email": "startup_admin_juli@gmail.com",
        "created_at": "2021-04-12T08:56:22.550Z",
        "updated_at": "2021-04-12T08:56:22.550Z",
        "first_name": "Juli",
        "last_name": "Lee",
        "accelerator_id": 1,
        "startup_id": 2
      },
      ...
    ]
  }

  DESC

  def show
    render json: @startup.as_json(methods: [:assessments_risk_list, :members, :startup_admins])
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

  === Success response body(admins_for_startup shows only for SuperAdmin or Admin)
  {
    "id": 1,
    "name": "New name",
    "accelerator_id": 1,
    "created_at": "2021-04-09T19:04:59.356Z",
    "updated_at": "2021-05-24T12:59:11.745Z",
    "admins_for_startup": [
      {
        "id": 1,
        "email": "admin@gmail.com",
        "created_at": "2021-04-09T18:49:05.376Z",
        "updated_at": "2021-04-09T18:49:05.376Z",
        "first_name": "Admin",
        "last_name": "Adm",
        "accelerator_id": 1,
        "startup_id": null
      }
    ]
  }

  DESC

  def update
    startup_params_update = startup_admins_params

    if @startup.update(startup_params_update)
      if current_user.super_admin? || current_user.admin?
        StartupsService::SendEmailToAssignedAdmins.call(startup_params_update, @startup, current_user) if startup_params_update[:admins_startups_attributes]
        render json: @startup.as_json(methods: :admins_for_startup)
      else
        render json: @startup
      end

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
