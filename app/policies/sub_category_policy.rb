class SubCategoryPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def update_progress?
    admin? || member? || super_admin?
  end
end
