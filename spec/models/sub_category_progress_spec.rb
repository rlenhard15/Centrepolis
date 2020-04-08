require 'rails_helper'

RSpec.describe SubCategoryProgress, type: :model do
  describe "Associations" do
    it { should belong_to(:customer).without_validating_presence }
    it { should belong_to(:sub_category).without_validating_presence }
  end
end
