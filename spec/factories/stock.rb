require 'faker'


FactoryBot.define do
  factory :stock do
    symbol { 'AMZN' }
    association :user
  end
end
