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
        scope.all
      else
        scope.none
      end
    end
  end

  def create?
    super_admin? && Accelerator.ids.include?(record.accelerator_id)
  end
end
