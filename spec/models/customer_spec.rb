require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe "Associations" do
    it { should have_many(:sub_category_progresses).dependent(:destroy) }
    it { should belong_to(:admin).with_foreign_key('created_by') }
    it { should have_many(:assessment_progresses).dependent(:destroy) }
  end
end
