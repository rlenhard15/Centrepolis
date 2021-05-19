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
        scope.all
      elsif user.admin?
        scope.where(id: user.startup_ids)
      elsif user.startup_admin?
        scope.where(id: user.startup_id)
      elsif user.member?
        scope.where(id: user.startup_id)
      end
    end
  end

  def index?
    super_admin? || admin?
  end

  def create?
    super_admin? || can_admin_do_it?
  end

  def can_admin_do_it?
    admin? && user.accelerator_id == record.accelerator_id
  end
end
