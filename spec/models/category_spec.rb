require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "Create record" do
    let!(:category) { Category.create(title: "Movies")}

    it "Created record" do
      expect(category.errors).to be_empty
    end
  end
  describe "Associations" do
    it { should have_many(:sub_categories) }
  end
end
