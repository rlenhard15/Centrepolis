FactoryBot.define do
  factory :stage do
    title { "Test stage" }
    position { rand(1..100)}
  end
end
