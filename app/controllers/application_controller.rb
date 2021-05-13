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
    @accelerator_id ||= request.headers['Accelerator-Id'].to_i
  end

  def user_accelerator_id
    if !current_user.super_admin?
      current_user.accelerator_id
    else
      accelerator_id
    end
  end

end
