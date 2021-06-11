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

  def update?
    super_admin? || can_admin_do_show? || can_startup_admin_do_it?
  end

  def show?
    super_admin? || can_admin_do_show? || can_startup_admin_do_it? || can_member_do_it?
  end

  def index?
    super_admin? || admin?
  end

  def create?
    super_admin? || can_admin_do_it?
  end

  def destroy?
    super_admin? || admin?
  end

  def can_admin_do_show?
    admin? && user.startup_ids.include?(record.id)
  end

  def can_admin_do_it?
    admin? && user.accelerator_id == record.accelerator_id
  end

  def can_startup_admin_do_it?
    startup_admin? && user.startup_id == record.id
  end

  def can_member_do_it?
    member? && user.startup_id == record.id
  end
end
