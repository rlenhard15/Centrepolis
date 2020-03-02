class StagesController < ApplicationController
  before_action :set_sub_category, only: :index

  api :GET, 'api/categories/:category_id/sub_categories/:sub_category_id/stages'
  param :category_id, Integer, desc: "id of category"
  param :sub_category_id, Integer, desc: "id of sub_category"

  description <<-DESC

  === Request headers
    Authentication - string - required

  === Success response body
  [
    {
        "id": 8,
        "title": "first",
        "sub_category_id": 3,
        "created_at": "2020-02-20T15:44:54.996Z",
        "updated_at": "2020-02-20T15:44:54.996Z",
        "tasks": [
            {
                "id": 19,
                "title": "task7 for user_1",
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
