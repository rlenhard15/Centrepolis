class NotificationPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      return scope.none unless user

      if user.customer?
        scope.where(customer_id: user.id)
      end
    end
  end

  def index?
    !admin?
  end
end
