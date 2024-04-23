require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { FactoryBot.create(:user) }

  it "is valid with valid attributes" do
    expect(user).to be_valid
  end

  it "is not valid without a first name" do
    user.first_name = nil
    expect(user).not_to be_valid
    expect(user.errors[:first_name]).to include("Field should not be blank")
  end

  it "is not valid without a last name" do
    user.last_name = nil
    expect(user).not_to be_valid
    expect(user.errors[:last_name]).to include("Field should not be blank")
  end

  it "is not valid without an email" do
    user.email = nil
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("Field should not be blank")
  end

  describe ".update_balance" do
    context "when action is 'buy'" do
      it "decreases the user's balance by the total amount" do
        initial_balance = user.balance
        total_amount = 500

        User.update_balance(user, "buy", total_amount)

        expect(user.balance).to eq(initial_balance - total_amount)
      end
    end

    context "when action is 'sell'" do
      it "increases the user's balance by the total amount" do
        initial_balance = user.balance
        total_amount = 300

        User.update_balance(user, "sell", total_amount)

        expect(user.balance).to eq(initial_balance + total_amount)
      end
    end
  end
end
