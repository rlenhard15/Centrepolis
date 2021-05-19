require 'rails_helper'

RSpec.describe Member, type: :model do
  describe "Associations" do
    it { should belong_to(:accelerator).with_foreign_key('accelerator_id') }
    it { should belong_to(:startup).with_foreign_key('startup_id') }
    it { should have_many(:notifications) }
  end

  describe "callbacks" do
    let!(:accelerator)       { create(:accelerator) }
    let!(:admin)             { create(:admin, accelerator_id: accelerator.id) }
    let!(:startup)           { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
      let!(:member)          { create(:member, startup_id: startup.id, accelerator_id: accelerator.id) }

    it { expect(member).to callback(:send_email).after(:create) }
  end
end
