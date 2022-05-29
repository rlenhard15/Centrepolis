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
      nil
    end
  end

  def create_admin
    email = user_params[:email].downcase.strip
    existing = User.where(email: email).first
    if existing
      User.update(existing.id, { type: 'Admin' })
    end
    user = existing || Admin.create(
      email: user_params[:email],
      first_name: user_params[:first_name],
      last_name: user_params[:last_name],
      accelerator_id: user_params[:accelerator_id] || user_accelerator_id,
      password: user_random_password,
      type: 'Admin'
    )
    if user.type != 'Admin'
        user.update({ type: 'Admin' })
    end

    user_startup = nil
    if @current_user.type != 'SuperAdmin'
      user_startup = get_user_startup(user)
    end
    [user, user_startup]
  end

  def create_user_for_startup
    email = user_params[:email].downcase.strip
    existing = User.where(email: email).first
    user = existing || User.create(
      email: email,
      first_name: user_params[:first_name],
      last_name: user_params[:last_name],
      accelerator_id: user_params[:accelerator_id] || user_accelerator_id,
      password: user_random_password,
      type: 'Member'
    )
    [user, get_user_startup(user)]
  end

  def get_user_startup(user)
    existing_startup = UsersStartup.where(startups_id: user_params[:startup_id], user_id: user.id).first
    user_startup = existing_startup || user.users_startups.create(
        is_team_lead: user_type == 'TeamLead',
        startups_id: user_params[:startup_id]
    )
    if not existing_startup.nil?
      existing_startup.update(is_team_lead: user_type == 'TeamLead')
    end
    user_startup
  end

  def user_random_password
    Devise.friendly_token.first(8)
  end

end
