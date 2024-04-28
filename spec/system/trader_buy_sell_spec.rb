require 'rails_helper'
require 'faker'

RSpec.describe 'Trading', type: :system do
  let(:trader) { FactoryBot.create(:user_new, admin: false) }
  let(:company) { FactoryBot.create(:stock, user: trader) }

  before do
    login_as(trader, scope: :user)
  end

  it 'allows buying a stock if balance is sufficient' do
    Capybara.default_max_wait_time = 30
    visit buy_new_trader_path(company.symbol)

    fill_in :quantity, with: 5
    click_button 'Buy'

    expect(page).to have_current_path(portfolio_trader_path(trader))
  end

  it 'does not allow buying a stock if balance is insufficient' do
    Capybara.default_max_wait_time = 30
    trader.update(balance: 8.00)

    visit buy_new_trader_path(company.symbol)

    fill_in :quantity, with: 5
    click_button 'Buy'

    expect(page).to have_current_path(buy_new_trader_path(company.symbol))
  end

  it 'allows selling a stock if stock quantity is not zero' do
    Capybara.default_max_wait_time = 30
    company.update(shares: 10)

    visit sell_new_trader_path(company.symbol)

    fill_in :quantity, with: 5
    click_button 'Sell'

    expect(page).to have_current_path(portfolio_trader_path(trader))
  end

  it 'does not allow selling a stock if stock quantity is zero' do
    Capybara.default_max_wait_time = 30
    company.update(shares: 0)

    visit sell_new_trader_path(company.symbol)

    fill_in 'quantity', with: 5
    click_button 'Sell'

    expect(page).to have_current_path(sell_new_trader_path(company.symbol))
  end
end
