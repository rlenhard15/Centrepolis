FactoryBot.define do
  factory :assessment_progress do
    risk_value  { rand(1..100.0) }
  end
end
