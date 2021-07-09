require 'rails_helper'

RSpec.describe Accelerator, type: :model do
  describe "Associations" do
    it { should have_many(:admins).with_foreign_key('accelerator_id') }
    it { should have_many(:team_leads).with_foreign_key('accelerator_id') }
    it { should have_many(:members).with_foreign_key('accelerator_id') }
  end
end
