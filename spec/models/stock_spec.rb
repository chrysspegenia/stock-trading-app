require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe '.create_or_update_stock' do
    let(:symbol) { Faker::Finance.ticker }
    let(:user) { FactoryBot.create(:user) }
    let(:company_name) { Faker::Company.name }

    context 'when stock does not exist' do
      it 'creates a new stock' do
        stock = Stock.create_or_update_stock(symbol, user, company_name)

        expect(stock.symbol).to eq(symbol)
        expect(stock.user).to eq(user)
        expect(stock.name).to eq(company_name)
      end
    end

    context 'when stock already exists' do
      let!(:existing_stock) { FactoryBot.create(:stock, symbol: symbol, user: user, name: company_name) }

      it 'updates the existing stock' do
        stock = Stock.create_or_update_stock(symbol, user, company_name)

        expect(stock.id).to eq(existing_stock.id)
        expect(stock.symbol).to eq(symbol)
        expect(stock.user).to eq(user)
        expect(stock.name).to eq(company_name)
      end
    end
  end
end
