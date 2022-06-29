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
    @accelerator_id ||= params[:accelerator_id].to_i
  end

  def startup_id
    @startup_id ||= params[:startup_id].to_i
  end

  def user_accelerator_id
    if !current_user.super_admin?
      current_user.accelerator_id
    else
      accelerator_id
    end
  end

  def set_startup
    raise Pundit::NotAuthorizedError unless startup_ids_for_current_user.include?(startup_id)
    @startup = policy_scope(Startup).find(@startup_id)
  end

  def startup_ids_for_current_user
    policy_scope(Startup)&.ids
  end

end
