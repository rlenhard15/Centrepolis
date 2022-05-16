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
        scope.joins(users: [:users_startup]).where("users_startups.startups_id IN (?) ", user.startup_ids)
      elsif user.member?
        scope.joins(users: [:users_startup])
             .where("users.id = ? OR users_startups.startups_id IN ?", user.id, user.leads_teams)
      end
    end
  end

  def index?
    super_admin? || admin? || member?
  end

  def create?
    super_admin? || admin? || can_startup_admin_do_it?
  end

  def destroy?
    can_super_admin_do_it? || can_admin_do_it? || can_startup_admin_do_it?
  end

  def update?
    can_super_admin_do_it? || can_admin_do_it? || can_startup_admin_do_it?
  end

  def mark_task_as_completed?
    can_do_it?
  end

  def send_task_reminder?
    can_super_admin_do_it? || can_admin_do_it? || can_startup_admin_do_it?
  end

  def show?
    can_do_it?
  end

  def can_startup_admin_do_it?
    user.leads_teams&.include?(record.startup_id)
  end

  def can_do_it?
    can_super_admin_do_it? || can_admin_do_it? || can_member_do_it?
  end

  def can_super_admin_do_it?
    super_admin?
  end

  def can_admin_do_it?
    puts [admin?, user.startup_ids, record&.startup_id].inspect
    admin? && user.startup_ids.include?(record&.startup_id)
  end

  def can_member_do_it?
    user.task_ids&.include?(record.id) || user.leads_teams&.include?(record.startup_id)
  end
end
