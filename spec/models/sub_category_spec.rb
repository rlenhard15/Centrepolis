require 'rails_helper'

RSpec.describe SubCategory, type: :model do
  describe "Create record" do
    let!(:category) {Category.create(title: "Movies")}
    let!(:sub_category) {SubCategory.create(title:"Star Wars", category_id: category.id)}

    it "Created record" do
      expect(sub_category.errors).to be_empty
    end
  end

  describe "Associations" do
    it {should belong_to(:category)}
    it { should have_many(:stages) }
  end
end
