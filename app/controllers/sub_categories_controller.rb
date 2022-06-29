class SubCategoriesController < ApplicationController

  before_action :authorize_user!,
                :check_startup,
                :set_sub_category_progress,
                :set_assessment,
                :set_assessment_progress

  api :POST, 'api/assessments/:assessment_id/categories/:category_id/sub_categories/:id/update_progress?current_stage_id=:current_stage_id&startup_id=:startup_id', 'Only Admin, StartupAdmin and Member can update progress'

  param :assessment_id, Integer, desc: 'ID of current assessment', required: true
  param :category_id, Integer, desc: 'ID of current category', required: true
  param :id, Integer, desc: 'ID of current sub category', required: true
  param :current_stage_id, Integer, desc: 'ID of stage selected by user', required: true
  param :startup_id, Integer, desc: 'ID of startup, required if current_user is Admin, StartupAdmin, Member'

  description <<-DESC

    === Request headers
      Authentication - string - required
          Example of Authentication header : "Bearer TOKEN_FETCHED_FROM_SERVER_DURING_REGISTRATION"
      Accelerator-Id - integer - required
          Example of Accelerator-Id header : 1

    === Success response body
    {
      "message": "Progress updates successfully",
      "assessment_risk": "7.45098039215686"
    }
  DESC

  def update_progress
    old_stage = @sub_category_progress.current_stage
    if @sub_category_progress.update(current_stage_id: params[:current_stage_id]) && @assessment_progress.update(risk_value: assessment_risk_value)
      stage = @sub_category_progress.current_stage
      tasks = Task.where(startup_id: @sub_category_progress.startup_id, sub_category_id: @sub_category_progress.sub_category_id)
      tasks.each do |task|
        puts [task.stage.position, stage.position, old_stage.position].inspect
        if task.stage.position <= stage.position && old_stage.position < task.stage.position
          puts('UPDATING')
          if task.update(status: 1)
            TasksService::EmailTaskCompleted.call(task, current_user)
          else
            render json: [task.errors], status: :unprocessable_entity
          end
        elsif task.status == 'completed' && stage.position < task.stage.position
          task.update(status: 0)
        end
      end
      AssessmentsService::SendEmailUpdateProgress.call(@sub_category_progress, @assessment_progress, current_user)

      render json: {
        message: "Progress updates successfully",
        assessment_risk: assessment_risk_value
      }, status: 200
    else
      render json: [@sub_category_progress.errors, @assessment_progress.errors], status: :unprocessable_entity
    end
  end

  private

  def authorize_user!
    authorize SubCategory
  end

  def check_startup
    raise Pundit::NotAuthorizedError unless set_startup
  end

  def set_assessment_progress
    @assessment_progress = @startup.assessment_progresses.where(
      assessment_id: @assessment.id
    ).first_or_create
  end

  def set_sub_category_progress
    @sub_category_progress = @startup.sub_category_progresses.where(
      sub_category_id: params[:id]
    ).first_or_create
  end

  def assessment_risk_value
    @assessment_risk_value ||= @assessment.assessment_risk(@startup.id)
  end

  def set_assessment
    @assessment = Assessment.find(params[:assessment_id])
  end
end
