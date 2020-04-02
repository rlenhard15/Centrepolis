class SubCategoriesController < ApplicationController

  before_action :authorize_user!,
                :set_sub_category_progress,
                :set_assessment,
                :set_assessment_progress

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
    if @sub_category_progress.update(current_stage_id: params[:current_stage_id]) && @assessment_progress.update(risk_value: assessment_risk_value)
      render json: { body: "Progress updates successfully" }, status: 200
    else
      render json: [@sub_category_progress.errors, @assessment_progress.errors], status: :unprocessable_entity
    end
  end

  private

  def authorize_user!
    authorize SubCategory
  end

  def set_assessment_progress
    @assessment_progress = current_user.assessment_progresses.where(
      assessment_id: @assessment.id
    ).first_or_create
  end

  def set_sub_category_progress
    @sub_category_progress = current_user.sub_category_progresses.where(
      sub_category_id: params[:id]
    ).first_or_create
  end

  def assessment_risk_value
    @assessment.assessment_risk(current_user.id)
  end

  def set_assessment
    @assessment = Assessment.find(params[:assessment_id])
  end
end
