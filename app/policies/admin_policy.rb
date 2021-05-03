class AdminPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      return scope.none unless user

      if user.super_admin?
        scope.where(accelerator_id: user.accelerator_id)
      else
        scope.none
      end
    end
  end

  def create?
    super_admin? && user.accelerator_id == record.accelerator_id
  end
end
