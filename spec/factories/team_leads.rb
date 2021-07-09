FactoryBot.define do
  factory :team_lead do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
    type {"TeamLead"}
    phone_number { Faker::PhoneNumber.cell_phone }
  end
end
