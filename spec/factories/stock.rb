require 'faker'

FactoryBot.define do
  factory :stock do
    symbol { Faker::Finance.ticker }
    association :user
  end
end
