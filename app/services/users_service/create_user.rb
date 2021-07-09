class UsersService::CreateUser < ApplicationService
  attr_accessor :user_type, :user_params, :user_accelerator_id, :current_user

  def initialize(user_params, accelerator_id, current_user)
    @user_type = user_params[:type]
    @user_params = user_params
    @user_accelerator_id = accelerator_id
    @current_user = current_user
  end

  def call
    create_user
  end

  private

  def create_user
    if user_type == 'Admin'
      create_admin
    elsif user_type == 'TeamLead' || user_type == 'Member'
      create_user_for_startup
    else
      return nil
    end
  end

  def create_admin
    Admin.new(
      email: user_params[:email],
      accelerator_id: user_accelerator_id,
      password: user_random_password
    )
  end

  def create_user_for_startup
    User.new({
      email: user_params[:email],
      accelerator_id: user_accelerator_id,
      password: user_random_password,
      startup_id: get_user_startup_id,
      type: user_type
    })
  end

  def user_random_password
    Devise.friendly_token.first(8)
  end

  def get_user_startup_id
    startup_id = current_user.startup_admin? ? current_user.startup_id : user_params[:startup_id]
  end

end
