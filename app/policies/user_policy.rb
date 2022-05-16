class UserPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      return scope.none unless user

      if user.super_admin?
        scope.all
      elsif user.admin?
        scope.joins(:users_startup).where('users_startups.startups_id': user.startup_ids)
      elsif user.member?
        scope.joins(:users_startup).where('users_startups.startups_id': user.leads_teams)
      end
    end
  end

  def create?
    super_admin? || admin? || super_admin?
  end

  def destroy?
    super_admin? || can_admin_do_it?
  end

  def startup_admin
    raise ArgumentError.new("OH NO")
  end

  def index?
    super_admin? || admin? || member?
  end

  def change_password?
    super_admin? || admin? || member?
  end

  def update_email_notification?
    super_admin? || admin? || member?
  end

  def update_profile?
    super_admin? || admin? || member?
  end

  def can_admin_do_it?
    admin? && (user.startup_ids & record.startup_ids).any?
  end
end
