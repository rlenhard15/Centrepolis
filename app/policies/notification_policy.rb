class NotificationPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      return scope.none unless user

      if user.super_admin?
        scope.where(user_id: user.id)
      elsif user.admin?
        scope.where(user_id: user.id)
      elsif user.member?
        scope.where(user_id: user.id)
      end
    end
  end

  def mark_as_readed?
    can_super_admin_do_it || can_admin_do_it || can_startup_admin_do_it || can_member_do_it
  end

  def mark_as_readed_all?
    super_admin? || admin? || member?
  end

  def index?
    super_admin? || admin? || member?
  end

  def can_super_admin_do_it
    super_admin? && user.id == record.user_id
  end

  def can_admin_do_it
    admin? && user.id == record.user_id
  end

  def can_member_do_it
    member? && user.id == record.user_id
  end
end
