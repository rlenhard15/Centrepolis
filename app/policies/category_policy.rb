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
      elsif user.customer?
        scope.eager_load(sub_categories: :sub_category_progresses).where("sub_category_progresses.customer_id = ?", user.id)
      end
    end
  end
end
