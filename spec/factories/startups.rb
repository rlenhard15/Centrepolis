FactoryBot.define do
  factory :startup do
    name { Faker::Company.name }
  end
end
