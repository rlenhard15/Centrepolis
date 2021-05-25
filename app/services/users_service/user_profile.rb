class UsersService::UserProfile < ApplicationService
  attr_accessor :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def call
    user_profile_info
  end

  def user_profile_info
    if current_user.member? || current_user.startup_admin?
      current_user.as_json(include: :startup)
    elsif current_user.admin?
      current_user.as_json(methods: :startups)
    elsif current_user.super_admin?
      current_user
    end
  end
end
