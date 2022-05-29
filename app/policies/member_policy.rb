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
      else
        scope.none
      end
    end
  end

  def index?
    super_admin? || admin? || can_startup_admin_do_it(user, record.startup_ids)
  end

  def create?
    can_do_it(user, record.accelerator_id, record.startup_ids)
  end

  def self.can_do_it(user, accelerator_id, startup_ids = [])
    can_super_admin_do_it(user) || can_admin_do_it(user, accelerator_id) || can_startup_admin_do_it(user, startup_ids)
  end

  def self.can_super_admin_do_it(user)
    user.super_admin?
  end

  def self.can_admin_do_it(user, accelerator_id)
    user.admin? && user.accelerator_id == accelerator_id
  end

  def self.can_startup_admin_do_it(user, startup_ids)
    (user.leads_teams & startup_ids).any?
  end
end
