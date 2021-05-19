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
        scope.joins(:users)
      elsif user.admin?
        scope.joins(:users).where("users.startup_id IN (?) ", user.startup_ids)
      elsif user.startup_admin?
        scope.joins(:users).where("tasks.id IN (?)", user.task_ids)
      elsif user.member?
        scope.joins(:users).where("users.id = ?", user.id)
      end
    end
  end

  def index?
    super_admin? || admin? || startup_admin? || member?
  end

  def create?
    startup_admin?
  end

  def destroy?
    can_startup_admin_do_it?
  end

  def update?
    can_startup_admin_do_it?
  end

  def mark_task_as_completed?
    can_do_it?
  end

  def show?
    can_do_it?
  end

  def can_do_it?
    can_super_admin_do_it? || can_admin_do_it? || can_startup_admin_do_it? || can_member_do_it?
  end

  def can_super_admin_do_it?
    super_admin?
  end

  def can_admin_do_it?
    admin? && user.startup_ids.include?(record.users&.members&.where(startup_id: user.startup_ids)&.first&.startup_id)
  end

  def can_startup_admin_do_it?
    startup_admin? && user.id == record.users&.where("users.id = ?", user.id)&.first&.id
  end

  def can_member_do_it?
    member? && user.task_ids&.include?(record.id)
  end
end
