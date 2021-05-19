class SubCategoryPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def update_progress?
    admin? || startup_admin? || member?
  end
end
