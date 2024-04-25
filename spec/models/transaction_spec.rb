require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:stock) { FactoryBot.create(:stock) }
  let(:quantity) { 10 }
  let(:price) { 50 }
  let(:action) { 'buy' }

  describe '.create_transaction' do
    it 'creates a new transaction with valid attributes' do
      transaction = Transaction.create_transaction(user, stock, quantity, price, action)

      expect(transaction.user).to eq(user)
      expect(transaction.stock).to eq(stock)
      expect(transaction.quantity).to eq(quantity)
      expect(transaction.price).to eq(price)
      expect(transaction.action).to eq(action)
      expect(transaction.total_amount).to eq(price * quantity)
      expect(transaction).to be_valid
    end

    it 'does not create a transaction with negative quantity' do
      transaction = Transaction.create_transaction(user, stock, -5, price, action)

      expect(transaction).not_to be_valid
      expect(transaction.errors[:quantity]).to include('must be greater than or equal to 0')
    end
  end
end
