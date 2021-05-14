require 'rails_helper'

RSpec.describe AssessmentProgress, type: :model do
  describe "Associations" do
    it { should belong_to(:assessment) }
    it { should belong_to(:startup) }
  end
end
