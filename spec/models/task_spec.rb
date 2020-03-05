require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "Create record" do
    let!(:category) {create(:category)}
    let!(:sub_category) {create(:sub_category, category_id: category.id)}
    let!(:stage) {create(:stage, sub_category_id: sub_category.id)}
    let!(:user) {create(:user)}
    let!(:task) {create(:task, stage_id: stage.id, user_id: user.id)}

    it "Created record" do
      expect(task.errors).to be_empty
    end
  end

  describe "Associations" do
    it {should belong_to(:stage)}
    it { should belong_to(:user) }
  end
end
