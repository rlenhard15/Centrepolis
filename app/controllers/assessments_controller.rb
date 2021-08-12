class AssessmentsController < ApplicationController
  before_action :set_startup, only: :index
  before_action :set_assessment, only: :show

  api :GET, 'api/assessments', "List of assessments names with risks for startup"
  param :startup_id, Integer, desc: "id of a startup, required if current_user is SuperAdmin or Admin", required: true

  description <<-DESC

  === Request headers
  SuperAdmin, Admin, StartupAdmin, Member can perform this action
    SuperAdmin   - can see all startups of any accelerator;
    Admin        - can see startups that were created by the admin;
    StartupAdmin - can see only a startup of the StartupAdmin;
    Member       - can see only a startup of the Member
  Authentication - string - required
    Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
  Accelerator-Id - integer - required
    Example of Accelerator-Id header : 1

  === Success response body
  [
    {
      "id": 4,
      "name": "Assessment_1",
      "created_at": "2020-04-01T17:29:50.528Z",
      "updated_at": "2020-04-01T17:29:50.528Z",
      "risk_value": "3.92156862745098"
    },
    ...
  ]
  DESC

  def index
    @assessments = policy_scope(Assessment)

    render json: assessments_changed_order
  end

  api :GET, 'api/assessments/:id', "Request for a certain assessment and related categories, sub_categories and stages"
  param :id, Integer, desc: "id of assessment",  required: true

  description <<-DESC

  === Request headers
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
    Accelerator-Id - integer - required
      Example of Accelerator-Id header : 1

  === Success response body
  {
    "id": 1,
    "name": "First assessment",
    "created_at": "2020-03-14T20:13:27.006Z",
    "updated_at": "2020-03-14T20:13:27.006Z",
    "description_with_child_models": [
      {
        "id": 3,
        "title": "First category",
        "created_at": "2020-02-20T15:32:46.379Z",
        "updated_at": "2020-03-14T20:16:11.530Z",
        "accessment_id": 1,
        "sub_categories": [
          {
            "id": 1,
            "title": "First sub_category",
            "category_id": 3,
            "created_at": "2020-02-20T15:40:49.793Z",
            "updated_at": "2020-02-20T15:40:49.793Z",
            "stages": [
              {
                "id": 5,
                "title": "First stage",
                "sub_category_id": 1,
                "created_at": "2020-02-20T15:44:10.603Z",
                "updated_at": "2020-02-20T15:44:10.603Z"
              },
              ...
            ]
          },
          ...
        ]
      },
      ...
    ]
  }

  DESC

  def assessments_changed_order
    assessments_new_order ||= [
      @assessments.where(id: 1).with_assessment_progresses(@startup_id).first,
      @assessments.where(id: 3).with_assessment_progresses(@startup_id).first,
      @assessments.where(id: 2).with_assessment_progresses(@startup_id).first
    ]
  end

  def show
    render json: @assessment.as_json(methods: :description_with_child_models)
  end

  private

  def set_startup
    raise Pundit::NotAuthorizedError unless @startup_id = startup_id_for_current_user
  end

  def startup_id_for_current_user
    if current_user.admin?
      (policy_scope(Startup)&.ids & [params[:startup_id].to_i]).first
    elsif current_user.super_admin?
      (policy_scope(Startup)&.for_accelerator(user_accelerator_id)&.ids & [params[:startup_id].to_i]).first
    else
      current_user.startup_id
    end
  end

  def set_assessment
    @assessment = Assessment.find(params[:id])
  end
end
