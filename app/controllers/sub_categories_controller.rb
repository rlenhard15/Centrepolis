class SubCategoriesController < ApplicationController

  before_action :authorize_user!,
                :set_sub_category_progress

  api :POST, 'api/assessments/:assessment_id/categories/:category_id/sub_categories/:id/update_progress?current_stage_id=:current_stage_id', 'Only customer can update progress'

  param :assessment_id, Integer, desc: 'ID of current assessment', required: true
  param :category_id, Integer, desc: 'ID of current category', required: true
  param :id, Integer, desc: 'ID of current sub category', required: true
  param :current_stage_id, Integer, desc: 'ID of stage selected by user', required: true

  description <<-DESC

    === Request headers
      Only customer can perform this action
        Authentication - string - required
          Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"

    === Success response body
    {
      "body": "Progress updates successfully"
    }
  DESC
  def update_progress
    if @sub_category_progress.update(current_stage_id: params[:current_stage_id])
      render json: { body: 'Progress updates successfully' }, status: 200
    else
      render json: @sub_category_progress.errors, status: :unprocessable_entity
    end
  end

  private

  def set_sub_category_progress
    @sub_category_progress = current_user.sub_category_progresses.where(
      sub_category_id: params[:id]
    ).first_or_create
  end

end
