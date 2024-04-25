require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe '#create_or_update_stock' do
    let(:user) { FactoryBot.create(:user) }

    it 'creates a new stock with the specified symbol and associated user' do
      stock = FactoryBot.create(:stock, user: user)
      expect(stock).to be_persisted
      expect(stock.symbol).to eq("AAPL")
      expect(stock.user).to eq(user)
    end
  end
end

RSpec.describe Stock, type: :model do
  describe '.create_or_update_stock' do
    let(:symbol) { 'AAPL' }
    let(:user) { FactoryBot.create(:user) }
    let(:company_name) { 'Apple Inc.' }

    context 'when stock does not exist' do
      it 'creates a new stock' do
        stock = Stock.create_or_update_stock(symbol, user, company_name)

        expect(stock.symbol).to eq(symbol)
        expect(stock.user).to eq(user)
        expect(stock.name).to eq(company_name)
      end
    end

    context 'when stock already exists' do
      let!(:existing_stock) { FactoryBot.create(:stock, symbol: symbol, user: user) }

      it 'updates the existing stock' do
        stock = Stock.create_or_update_stock(symbol, user, 'New Company Name')

        expect(stock.id).to eq(existing_stock.id)
        expect(stock.symbol).to eq(symbol)
        expect(stock.user).to eq(user)
        expect(stock.name).to eq('New Company Name')
      end
    end
  end
end
