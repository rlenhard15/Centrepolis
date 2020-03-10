require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "Create record" do
    let!(:category) { create(:category)}

    it "Created record" do
      expect(category.errors).to be_empty
    end
    it "has one category after create one" do
      expect(Category.count).to eq(1)
    end
  end
  describe "Associations" do
    it { should have_many(:sub_categories) }
  end
end
