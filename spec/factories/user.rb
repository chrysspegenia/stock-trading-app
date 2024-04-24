FactoryBot.define do
  factory :user do
    sequence(:first_name) { |n| "Dex#{n}" }
    sequence(:last_name) { |n| "Boo#{n}" }
    sequence(:email) { |n| "dexboo#{n}@example.com" }
    password { "password123" }
    confirmed_at { Time.now }
    admin { false }
    approved { true }
    balance { 1000.00 }
  end
end
