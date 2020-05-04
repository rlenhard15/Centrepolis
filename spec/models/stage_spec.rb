require 'rails_helper'

RSpec.describe Stage, type: :model do
  describe "Associations" do
    it { should belong_to(:sub_category) }
    it { should have_many(:tasks).dependent(:destroy) }
  end

  describe "validates" do
    it { should validate_uniqueness_of(:position).scoped_to(:sub_category_id).with_message("should be uniq for one sub_category") }
  end
end
