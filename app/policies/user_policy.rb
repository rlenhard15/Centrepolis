class UserPolicy < ApplicationPolicy
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
      elsif user.startup_admin?
        scope.where(startup_id: user.startup_id)
      elsif user.member?
        scope.none
      end
    end
  end
end
