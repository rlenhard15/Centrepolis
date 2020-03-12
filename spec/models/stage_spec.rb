require 'rails_helper'

RSpec.describe Stage, type: :model do
  describe "Associations" do
    it { should belong_to(:sub_category) }
    it { should have_many(:tasks).dependent(:destroy) }
  end
end
