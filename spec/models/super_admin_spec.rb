require 'rails_helper'

RSpec.describe SuperAdmin, type: :model do

  describe "callbacks" do
    let!(:super_admin) { create(:super_admin) }

    it { expect(super_admin).to callback(:send_email).after(:create) }
  end

end
