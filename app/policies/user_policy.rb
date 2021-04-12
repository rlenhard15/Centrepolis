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
        scope.where(accelerator_id: user.accelerator_id)
      elsif user.admin?
        scope.where(startup_id: user.startup_ids)
      elsif user.startup_admin?
        scope.where(startup_id: user.startup_id)
      elsif user.member?
        scope.none
      end
    end
  end

  def index?
    super_admin? || admin? || startup_admin?
  end
end
