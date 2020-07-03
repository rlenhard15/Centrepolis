require 'rails_helper'

RSpec.describe Accelerator, type: :model do
  describe "Associations" do
    it { should have_many(:users) }
  end
end
