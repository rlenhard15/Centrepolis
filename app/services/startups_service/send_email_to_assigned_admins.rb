class StartupsService::SendEmailToAssignedAdmins < ApplicationService
  attr_accessor :admin_ids_params, :startup, :current_user

  def initialize(admins_ids, startup, current_user)
    @admin_ids_params = admins_ids
    @startup = startup
    @current_user = current_user
  end

  def call
    if current_user.super_admin?
      send_email unless admin_ids_params[:admins_startups_attributes].empty?
    end
  end

  def send_email
    StartupsMailer.with(
      admin_ids: admin_ids,
      startup_id: startup.id
    ).email_for_assigned_admins.deliver_later
  end

  def admin_ids
    admins_ids_for_startup = admin_ids_params[:admins_startups_attributes].map { |admin| admin[:admin_id] }
  end

end
