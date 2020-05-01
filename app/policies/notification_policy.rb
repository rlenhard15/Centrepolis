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
      elsif user.admin?
        scope.none
      end
    end
  end

  def mark_as_readed?
    can_customer_do_it
  end

  def mark_as_readed_all?
    customer?  
  end

  def index?
    !admin?
  end

  def can_customer_do_it
    customer? && user.id == record.customer_id
  end
end
