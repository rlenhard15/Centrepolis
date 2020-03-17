class StagesController < ApplicationController
  before_action :set_sub_category, only: :index

  api :GET, 'api/assessments/:assessment_id/categories/:category_id/sub_categories/:sub_category_id/stages', "List of stages with related records tasks"
  param :assessment_id, Integer, desc: "id of assessment",  required: true
  param :category_id, Integer, desc: "id of category",  required: true
  param :sub_category_id, Integer, desc: "id of sub_category",  required: true

  description <<-DESC

  === Request headers
    Authentication - string - required
      Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

  === Success response body
  [
    {
        "id": 8,
        "title": "Title of stage",
        "sub_category_id": 3,
        "created_at": "2020-02-20T15:44:54.996Z",
        "updated_at": "2020-02-20T15:44:54.996Z",
        "tasks": [
            {
                "id": 19,
                "title": "Title of task",
                "stage_id": 8,
                "created_at": "2020-02-21T15:41:40.718Z",
                "updated_at": "2020-02-21T15:41:40.718Z",
                "user_id": 1,
                "status": "completed"
            },
            ...
        ]
    },
    ...
  ]
  DESC
  def index
    @stages = @sub_category.stages

    render json: @stages.to_json(include: :tasks)
  end

  private

  def set_sub_category
    @sub_category = SubCategory.find(params[:sub_category_id])
  end
end
