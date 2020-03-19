
  class UserPolicy < ApplicationPolicy
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
        else
          scope.none
        end
      end

    end

    def create?
      user.admin?
    end
  end
