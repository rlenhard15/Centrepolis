require 'rails_helper'

RSpec.describe Stage, type: :model do
  describe "Create record" do
    let!(:category) {Category.create(title: "Movies")}
    let!(:sub_category) {SubCategory.create(title:"Star Wars", category_id: category.id)}
    let!(:stage) {Stage.create(title:"first", sub_category_id: sub_category.id)}

    it "Created record" do
      expect(stage.errors).to be_empty
    end
  end

  describe "Associations" do
    it {should belong_to(:sub_category)}
    it { should have_many(:tasks) }
  end
end
