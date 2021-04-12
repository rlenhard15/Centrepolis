class TaskPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      return scope.none unless user

      if user.super_admin?
        scope.joins(:users).where("users.accelerator_id = ? ", user.accelerator_id).uniq
      elsif user.admin?
        scope.joins(:users).where("users.startup_id IN (?) ", user.startup_ids).uniq
      elsif user.startup_admin?
        scope.joins(:users).where("task_users.user_id = ?", user.id)
      elsif user.member?
        scope.joins(:users).where("task_users.user_id = ?", user.id)
      end
    end
  end

  def create?
    startup_admin?
  end

  def destroy?
    can_admin_do_it?
  end

  def update?
    can_admin_do_it?
  end

  def mark_task_as_completed?
    can_do_it?
  end

  def show?
    can_do_it?
  end

  def can_do_it?
    can_admin_do_it? || can_customer_do_it?
  end

  def can_admin_do_it?
    admin? && user.id == record.created_by
  end

  def can_customer_do_it?
    member? && user.id == record.user_id
  end
end
