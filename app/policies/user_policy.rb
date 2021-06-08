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
        scope.where(startup_id: user.startup_ids)
      elsif user.startup_admin?
        scope.where(startup_id: user.startup_id)
      elsif user.member?
        scope.none
      end
    end
  end

  def create?
    super_admin? || admin? || startup_admin?
  end

  def destroy?
    super_admin? || can_admin_do_it?
  end

  def index?
    super_admin? || admin? || startup_admin?
  end

  def change_password?
    super_admin? || admin? || startup_admin? || member?
  end

  def update_profile?
    super_admin? || admin? || startup_admin? || member?
  end

  def can_admin_do_it?
    admin? && user.startup_ids.include?(record.startup_id)
  end
end
