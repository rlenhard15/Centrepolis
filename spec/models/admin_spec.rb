require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe "Associations" do
    it { should have_many(:customers).with_foreign_key('created_by') }
  end
end
