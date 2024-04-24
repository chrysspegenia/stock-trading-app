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

  it "is not valid with a non-numeric balance" do
    user.balance = "invalid"
    expect(user).not_to be_valid
    expect(user.errors[:balance]).to include("Balance must be a number")
  end

  it "is not valid with a balance less than zero" do
    user.balance = -100
    expect(user).not_to be_valid
    expect(user.errors[:balance]).to include("Balance must be greater than or equal to zero")
  end

  it "is valid with a balance of zero" do
    user.balance = 0
    expect(user).to be_valid
  end

  it "is valid with a positive balance" do
    user.balance = 500
    expect(user).to be_valid
  end

  describe "#stock_transactions" do
    it "returns all transactions associated with the user through stocks" do
      user = FactoryBot.create(:user)
      stock1 = FactoryBot.create(:stock, user: user)
      transaction1 = FactoryBot.create(:transaction, stock: stock1, user: user)

      expect(user.stocks).to contain_exactly(stock1)

      transactions = Transaction.joins(:stock).where(stocks: { user_id: user.id })
      expect(transactions).to contain_exactly(transaction1)
    end
  end
end
