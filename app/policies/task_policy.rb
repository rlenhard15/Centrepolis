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
        scope.where(user_id: user.id)
      elsif user.customer?
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

  def task_completed?
    can_do_it?
  end

  def show?
    can_do_it?
  end

  def can_do_it?
    admin? || customer? && user == record.user
  end

  def can_admin_do_it?
    admin? && user == record.user
  end

  def customer?
    user.customer?
  end
end
