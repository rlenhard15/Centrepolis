class CategoriesController < ApplicationController
  before_action :set_category, :set_customer, only: :show

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
    render json: policy_scope(Category).for_assessment(params[:assessment_id])
  end

  api :GET, '/api/assessments/:assessment_id/categories/:id', "Request for a certain category with sub_categories, stages and current stages"
  param :id, Integer, desc: "id of category", required: true
  param :assessment_id, Integer, desc: "id of assessment", required: true
  param :id_customer, Integer, desc: "id of customer, required if current_user is admin", required: true

  description <<-DESC

  === Request headers
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

  === Success response body
  [
    {
      "title_sub_category": "First sub_category",
      "stages": [
        {
          "id": 5,
          "title": "First stage"
        },
        ...,
        {
          "current_stage_id": 5
        }
      ]
    },
    ...
  ]

  DESC

  def show
    render json: @category.sub_categories_status(@customer_id)
  end

  private

  def set_customer
    raise Pundit::NotAuthorizedError unless @customer_id = current_user.admin? ? params[:id_customer] : current_user.id
  end

  def set_category
    @category = policy_scope(Category).for_assessment(params[:assessment_id]).find(params[:id])
  end
end
