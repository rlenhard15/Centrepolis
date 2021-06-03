class AssessmentsService::SendEmailUpdateProgress < ApplicationService
  attr_accessor :sub_category_progress, :assessment_progress, :current_user, :startup

  def initialize(sub_category_progress, assessment_progress, current_user)
    @sub_category_progress = sub_category_progress
    @assessment_progress = assessment_progress
    @current_user = current_user
    @startup = Startup.find_by_id(@assessment_progress.startup_id)
  end

  def call
    send_email if @startup
  end

  private

  def send_email
    byebug
    to_admins
    to_startups_users
    to_current_user
  end

  def to_admins
    AssessmentsMailer.with(
      sub_category_progress_id: sub_category_progress.id,
      assessment_progress_id: assessment_progress.id,
      current_user_id: current_user.id,
      startup_id: startup.id
    ).email_progress_updated.deliver_later
  end

  def to_startups_users
    AssessmentsMailer.with(
      sub_category_progress_id: sub_category_progress.id,
      assessment_progress_id: assessment_progress.id,
      current_user_id: current_user.id,
      startup_id: startup.id
    ).email_progress_updated_to_startup_users.deliver_later
  end

  def to_current_user
    AssessmentsMailer.with(
      sub_category_progress_id: sub_category_progress.id,
      assessment_progress_id: assessment_progress.id,
      current_user_id: current_user.id,
      startup_id: startup.id
    ).email_progress_updated_to_current_user.deliver_later
  end
end
