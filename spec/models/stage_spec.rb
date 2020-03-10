require 'rails_helper'

RSpec.describe Stage, type: :model do
  describe "Create record" do
    let!(:category) {create(:category)}
    let!(:sub_category) {create(:sub_category, category_id: category.id)}
    let!(:stage) {create(:stage, sub_category_id: sub_category.id)}

    it "Created record" do
      expect(stage.errors).to be_empty
    end

    it "has one stage after create one" do
      expect(Stage.count).to eq(1)
    end
  end

  describe "Associations" do
    it {should belong_to(:sub_category)}
    it { should have_many(:tasks) }
  end
end
