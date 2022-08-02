class AcceleratorPolicy < ApplicationPolicy
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
        scope.where(id: user.accelerator_id)
      end
    end
  end

  def index?
    true
  end

  def create?
    super_admin?
  end
end
