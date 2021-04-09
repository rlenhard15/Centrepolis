class TaskPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      return scope.none unless user

      if user.admin?
        scope.where(created_by: user.id)
      elsif user.member?
        scope.where(user_id: user.id)
      end
    end
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
