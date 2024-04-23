FactoryBot.define do
  factory :user do
    first_name { "Dex" }
    last_name { "Boo" }
    email { "dexboo@example.com" }
    password { "password123" }
    confirmed_at { Time.now }
    admin { false }
    approved { true }
    balance { 1000 }
  end
end
