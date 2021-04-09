require 'rails_helper'

RSpec.describe Startup, type: :model do
  describe "Associations" do
    it { should have_many(:startup_admins).with_foreign_key('startup_id') }
    it { should have_many(:members).with_foreign_key('startup_id') }
    it { should have_many(:admins_startups).dependent(:destroy) }
    it { should have_many(:admins).through(:admins_startups) }
  end
end
