require 'rails_helper'

RSpec.describe SubCategory, type: :model do
  describe "Associations" do
    it { should belong_to(:category) }
    it { should have_many(:stages).dependent(:destroy) }
  end
end
