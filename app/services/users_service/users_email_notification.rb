class UsersService::UsersEmailNotification < ApplicationService
  attr_accessor :deleted_user, :current_user

  def initialize(deleted_user, current_user)
    @deleted_user = deleted_user
    @current_user = current_user
  end

  def call
    about_delete_admin_to_current_user if deleted_user && (current_user.super_admin? || current_user.admin?)
  end

  private

    def about_delete_admin_to_current_user
      UsersMailer.with(
        deleted_user: deleted_user,
        current_user_id: current_user.id
      ).email_after_delete_user.deliver_now
    end

end
