require 'rails_helper'

RSpec.describe SubCategory, type: :model do
  describe "Create record" do
    let!(:category)     { create(:category) }
    let!(:sub_category) { create(:sub_category, category_id: category.id) }

    it "has one sub_category after create one" do
      expect(SubCategory.count).to eq(1)
    end

    it "recieve errors if created record invalid" do
      expect(sub_category.errors).to be_empty
    end
  end

  describe "Associations" do
    it { should belong_to(:category) }
    it { should have_many(:stages) }
  end
end
