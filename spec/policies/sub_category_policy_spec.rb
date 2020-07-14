require 'rails_helper'

RSpec.describe SubCategoryPolicy, type: :policy do
  subject { described_class.new(user, sub_category) }

  let!(:assessment)       { create(:assessment) }
    let!(:category)       { create(:category, assessment_id: assessment.id) }
      let!(:sub_category) { create(:sub_category, category_id: category.id) }

  describe "user's type: Admin" do
    let!(:accelerator) { create(:accelerator) }
    let!(:user)        {create(:admin, accelerator_id: accelerator.id)}

    it { is_expected.to permit_actions(%i[update_progress]) }
  end

  describe "user's type: Customer" do
    let!(:accelerator) { create(:accelerator) }
    let!(:admin)       {create(:admin, accelerator_id: accelerator.id)}
      let!(:user)      {create(:customer, created_by: admin.id, accelerator_id: accelerator.id)}

    it { is_expected.to permit_actions(%i[update_progress]) }
  end
end
