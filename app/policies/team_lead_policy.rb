class TeamLeadPolicy < ApplicationPolicy
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
      else
        scope.none
      end
    end
  end

  def index?
    super_admin? || admin?
  end

  def create?
    puts record.inspect
    admin? && user.accelerator_id == record.accelerator_id
  end
end
