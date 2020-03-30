class CategoriesController < ApplicationController
  before_action :set_assessment, :set_customer
  before_action :set_category, :status_sub_categories_for_customer, only: :show

  api :GET, '/api/assessments/:assessment_id/categories', "List of categories"
  param :assessment_id, Integer, desc: "id of assessment",  required: true
  description <<-DESC

  === Request headers
    Only admin and customer can perform this action
      Authentication - string - required
        Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

  === Success response body for admin
  [
    {
      "id": 3,
      "title": "Category",
      "created_at": "2020-02-20T15:32:46.379Z",
      "updated_at": "2020-03-16T14:12:47.759Z",
      "assessment_id": 1
    },
    ...
  ]

  DESC

  def index
    render json: policy_scope(Category).current_assessment(@assessment.id)
  end

  api :GET, '/api/assessments/:assessment_id/categories/:id', "Request for a certain category with sub_categories, stages and current stages"
  param :id, Integer, desc: "id of category", required: true
  param :assessment_id, Integer, desc: "id of assessment", required: true

  description <<-DESC

  === Request headers
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

  === Success response body
  {
    "id": 3,
    "title": "Category",
    "created_at": "2020-02-20T15:32:46.379Z",
    "updated_at": "2020-03-16T14:12:47.759Z",
    "assessment_id": 1,
    "desc_info_for_category": [
      {
        "id": 1,
        "title": "SubCategory",
        "category_id": 3,
        "created_at": "2020-02-20T15:40:49.793Z",
        "updated_at": "2020-02-20T15:40:49.793Z",
        "stages": [
          {
            "id": 5,
            "title": "Stage",
            "created_at": "2020-02-20T15:44:10.603Z",
            "updated_at": "2020-03-25T15:00:03.466Z",
            "position": 1,
            "sub_category_id": 1
          },
          ...
        ]
      },
      ...
    ],
    "current_stages": [
      {
        "id": 18,
        "customer_id": 324,
        "sub_category_id": 1,
        "current_stage_id": 7,
        "created_at": "2020-03-26T16:33:34.308Z",
        "updated_at": "2020-03-27T10:18:01.872Z"
      },
      ...
    ]
  }

  DESC

  def show
    render json: @category.as_json(methods: :desc_info_for_category).merge({current_stages: @progresses})
  end

  private

  def set_customer
    raise Pundit::NotAuthorizedError unless @customer_id = current_user.admin? ? params[:id_customer] : current_user.id
  end

  def status_sub_categories_for_customer
    @customer = User.find(@customer_id)
    @progresses = @customer.sub_category_progresses
  end

  def set_category
    @category = policy_scope(Category).current_assessment(@assessment.id).find(params[:id])
  end

  def set_assessment
    @assessment = Assessment.find(params[:assessment_id])
  end
end
