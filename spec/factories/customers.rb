FactoryBot.define do
  factory :customer do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
    type {"Customer"}
  end
end
