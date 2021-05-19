class MemberPolicy < ApplicationPolicy
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
      else
        scope.none
      end
    end
  end

  def index?
    super_admin? || admin? || startup_admin?
  end

  def create?
    can_do_it?
  end

  def can_do_it?
    can_super_admin_do_it? || can_admin_do_it? || can_startup_admin_do_it?
  end

  def can_super_admin_do_it?
    super_admin? && Accelerator.ids.include?(record.accelerator_id)
  end

  def can_admin_do_it?
    admin? && user.startup_ids.include?(record.startup_id)
  end

  def can_startup_admin_do_it?
    startup_admin? && user.startup_id == record.startup_id
  end
end
