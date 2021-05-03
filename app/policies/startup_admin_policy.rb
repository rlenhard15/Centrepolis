class StartupAdminPolicy < ApplicationPolicy
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
      else
        scope.none
      end
    end
  end

  def index?
    super_admin? || admin?
  end

  def create?
    admin? && user.startup_ids.include?(record.startup_id) && user.accelerator_id == record.accelerator_id
  end
end
