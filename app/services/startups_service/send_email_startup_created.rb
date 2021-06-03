class StartupsService::SendEmailStartupCreated < ApplicationService
  attr_accessor :startup, :current_user, :super_admins

  def initialize(startup, current_user)
    @startup = startup
    @current_user = current_user
    @super_admins = SuperAdmin.all
  end

  def call
    send_email if startup && current_user
  end

  def send_email
    StartupsMailer.with(
      current_user_id: current_user.id,
      startup_id: startup.id,
      super_admin_ids: nil
    ).email_startup_created.deliver_now

    StartupsMailer.with(
      current_user_id: current_user.id,
      startup_id: startup.id,
      super_admin_ids: super_admin_ids
    ).email_startup_created_to_super_admins.deliver_now
  end

  def super_admin_ids
    if current_user.super_admin?
      super_admins_ids = super_admins.map { |admin| admin.id  if current_user.id != admin.id }
    else
      super_admins_ids = super_admins.map { |admin| admin.id }
    end

    super_admins_ids.compact
  end

end
