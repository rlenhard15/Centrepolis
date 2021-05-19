class StartupsController < ApplicationController

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
    @startup = Startup.new(startup_admins_params.merge({accelerator_id: user_accelerator_id}))

    authorize @startup

    if @startup.save
      render json: @startup.as_json(methods: :admins_for_startup), status: :created
    else
      render json: @startup.errors, status: :unprocessable_entity
    end
  end

  private

  def page_params
    params[:page]
  end

  def startup_admins_params
    if startup_params[:admins_startups_attributes]
      admins_ids_for_startup = startup_params[:admins_startups_attributes].map { |admin| admin[:admin_id] }
    end

    @admins = current_user.super_admin? ? policy_scope(User).where({id: admins_ids_for_startup, type: "Admin"}) : [current_user]
    raise Pundit::NotAuthorizedError if @admins.empty? || @admins.nil?

    validated_admins_ids_hash = []

    @admins.each do |admin|
      validated_admins_ids_hash.push({admin_id: admin.id})
    end
    startup_params_hash = startup_params.to_h
    startup_params_hash[:admins_startups_attributes] = validated_admins_ids_hash
    return startup_params_hash
  end

  def startup_params
    params.require(:startup).permit(:name, admins_startups_attributes: [ :admin_id ])
  end
end
