require 'rails_helper'

RSpec.describe SubCategoryPolicy, type: :policy do
  subject { described_class.new(user, sub_category) }

  let!(:assessment)       { create(:assessment) }
    let!(:category)       { create(:category, assessment_id: assessment.id) }
      let!(:sub_category) { create(:sub_category, category_id: category.id) }

  describe "user's type: SuperAdmin" do
    let!(:accelerator) { create(:accelerator) }
    let!(:user)        {create(:super_admin, accelerator_id: accelerator.id)}

    it { is_expected.to forbid_actions(%i[update_progress]) }
  end

  describe "user's type: Admin" do
    let!(:accelerator) { create(:accelerator) }
    let!(:user)        {create(:admin, accelerator_id: accelerator.id)}

    it { is_expected.to permit_actions(%i[update_progress]) }
  end

  describe "user's type: StartupAdmin" do
    let!(:accelerator) { create(:accelerator) }
    let!(:admin)       { create(:admin, accelerator_id: accelerator.id) }
      let!(:startup)   { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
    let!(:user)        {create(:team_lead, accelerator_id: accelerator.id, startup_id: startup.id)}

    it { is_expected.to permit_actions(%i[update_progress]) }
  end

  describe "user's type: Member" do
    let!(:accelerator) { create(:accelerator) }
    let!(:admin)       { create(:admin, accelerator_id: accelerator.id) }
      let!(:startup)   { create(:startup, accelerator_id: accelerator.id, admins_startups_attributes: [{admin_id: admin.id}]) }
      let!(:user)      {create(:member, startup_id: startup.id, accelerator_id: accelerator.id)}

    it { is_expected.to permit_actions(%i[update_progress]) }
  end
end
