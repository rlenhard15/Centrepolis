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
        scope.where(accelerator_id: user.accelerator_id)
      elsif user.member?
        scope.where(id: user.startup_ids)
      end
    end
  end

  def update?
    super_admin? || can_admin_do_show? || can_startup_admin_do_it?
  end

  def show?
    super_admin? || can_admin_do_show? || can_member_do_it?
  end

  def index?
    true
  end

  def create?
    super_admin? || can_admin_do_it?
  end

  def destroy?
    super_admin? || admin?
  end

  def can_startup_admin_do_it?
    user.leads_teams.include?(record.id)
  end

  def can_admin_do_show?
    admin? && user.accelerator_id == record.accelerator_id
  end

  def can_admin_do_it?
    admin? && user.accelerator_id == record.accelerator_id
  end

  def can_member_do_it?
    member? && user.startup_ids.include?(record.id)
  end
end
