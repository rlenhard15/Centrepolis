require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe "Associations" do
    it { should have_many(:admins_startups).with_foreign_key('admin_id').dependent(:destroy) }
    it { should have_many(:startups).through(:admins_startups) }
    it { should belong_to(:accelerator).with_foreign_key('accelerator_id') }
  end
end
