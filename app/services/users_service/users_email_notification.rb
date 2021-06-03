class UsersService::UsersEmailNotification < ApplicationService
  attr_accessor :deleted_admin, :current_user

  def initialize(deleted_admin, current_user)
    @deleted_admin = deleted_admin
    @current_user = current_user
  end

  def call
    about_delete_admin_to_super_admin if deleted_admin && current_user.super_admin?
  end

  private

    def about_delete_admin_to_super_admin
      UsersMailer.with(
        deleted_admin: deleted_admin,
        super_admin_id: current_user.id
      ).email_after_delete_admin.deliver_later
    end

end
