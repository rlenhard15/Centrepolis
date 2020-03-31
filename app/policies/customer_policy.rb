class CustomerPolicy < ApplicationPolicy
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
      else
        scope.none
      end
    end
  end
end