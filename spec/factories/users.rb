FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    first_name { "Devid" }
    last_name { "Smith" }
    company_name { Faker::Company.name }
  end
end
