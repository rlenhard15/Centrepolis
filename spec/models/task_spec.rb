require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "Create record" do
    let!(:category) {Category.create(title: "Movies")}
    let!(:sub_category) {SubCategory.create(title:"Star Wars", category_id: category.id)}
    let!(:stage) {Stage.create(title:"first", sub_category_id: sub_category.id)}
    let!(:user) {User.create(email: "user@gmail.com", password: 123456)}
    let!(:task) {Task.create(title:"Example task", stage_id: stage.id, user_id: user.id)}

    it "Created record" do
      expect(task.errors).to be_empty
    end
  end

  describe "Associations" do
    it {should belong_to(:stage)}
    it { should belong_to(:user) }
  end
end
