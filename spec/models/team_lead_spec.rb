require 'rails_helper'

RSpec.describe TeamLead, type: :model do
  describe "Associations" do
    it { should belong_to(:startup).with_foreign_key('startup_id') }
    it { should belong_to(:accelerator).with_foreign_key('accelerator_id') }
  end

  describe "callbacks" do
    let!(:accelerator)       { create(:accelerator) }
    let!(:admin)             { create(:admin, accelerator_id: accelerator.id) }
    let!(:startup)           { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
      let!(:team_lead)       { create(:team_lead, startup_id: startup.id, accelerator_id: accelerator.id) }

    it { expect(team_lead).to callback(:send_email).after(:create) }
    it { expect(team_lead).to callback(:send_email_about_delete_account).after(:destroy) }
  end
end
