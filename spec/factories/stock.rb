FactoryBot.define do
  factory :stock do
    symbol { AAPL }
    association :user
  end
end
