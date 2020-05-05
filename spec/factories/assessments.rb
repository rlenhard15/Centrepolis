FactoryBot.define do
  factory :assessment do
    name { Faker::Science.element }
  end
end
