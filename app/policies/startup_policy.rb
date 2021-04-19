class StartupPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      return scope.none unless user

      if user.super_admin?
        scope.where(accelerator_id: user.accelerator_id)
      elsif user.admin?
        scope.where(id: user.startup_ids)
      elsif user.startup_admin?
        user.startup
      elsif user.member?
        user.startup
      end
    end
  end

  def index?
    super_admin? || admin?
  end

  def create?
    super_admin? || admin?
  end
end
