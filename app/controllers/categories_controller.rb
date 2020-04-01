class CategoriesController < ApplicationController
  before_action :set_category, :set_customer, only: :show

  skip_before_action :authenticate_user!

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
      "title": "First category",
      "created_at": "2020-02-20T15:32:46.379Z",
      "updated_at": "2020-03-16T14:12:47.759Z",
      "assessment_id": 1
    },
    ...
  ]

  DESC

  def index
    render json: policy_scope(Category).for_assessment(params[:assessment_id])
  end

  api :GET, '/api/assessments/:assessment_id/categories/:id', "Request for a certain category with sub_categories, stages and current stages"
  param :id, Integer, desc: "id of category", required: true
  param :assessment_id, Integer, desc: "id of assessment", required: true
  param :customer_id, Integer, desc: "id of customer, required if current_user is admin", required: true

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
    "sub_categories_with_statuses": [
      {
        "title_sub_category": "Sub category",
        "current_stage_id": 5,
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
    ]
  }

  DESC

  def show
    render json: @category.as_json.merge(
      sub_categories: @category.sub_categories_with_statuses(@customer_id)
    )
  end

  private

  def current_user
    Admin.first
  end

  def set_customer
    raise Pundit::NotAuthorizedError unless @customer_id = current_user.admin? ? (current_user.customers.ids & [params[:customer_id]]).first : current_user.id
  end

  def set_category
    @category = policy_scope(Category).for_assessment(params[:assessment_id]).find(params[:id])
  end
end
