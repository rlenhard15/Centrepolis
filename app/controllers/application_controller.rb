class ApplicationController < ActionController::API
  include Pundit

  before_action :authenticate_user!

  rescue_from(Pundit::NotAuthorizedError) do
    
    render json:
      {
        notice: 'You do not have permission to perform this action'
      }, status: 403
  end

end
