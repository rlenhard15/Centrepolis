class CategoryPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      return scope.none unless user

      if user.admin?
        scope.all
      elsif user.member?
        scope.all
      end
    end
  end
end
