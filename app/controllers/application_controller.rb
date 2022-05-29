class ApplicationController < ActionController::API
  include Pundit

  before_action :authenticate_user!

  rescue_from(Pundit::NotAuthorizedError) do
    render json:
             {
               notice: 'You do not have permission to perform this action'
             }, status: 403
  end

  def accelerator_id
    @accelerator_id ||= params[:accelerator_id]
  end

  def user_accelerator_id
    if !current_user.super_admin?
      current_user.accelerator_id
    else
      accelerator_id
    end
  end

  def startup_id_for_current_user
    if current_user.admin?
      (policy_scope(Startup)&.ids & [params[:startup_id].to_i]).first
    elsif current_user.super_admin?
      (policy_scope(Startup)&.for_accelerator(user_accelerator_id)&.ids & [params[:startup_id].to_i]).first
    else
      (policy_scope(Startup)&.for_accelerator(user_accelerator_id)&.with_user(user.id)&.ids & [params[:startup_id].to_i]).first
    end
  end

end
