RSpec.describe 'Balance Update', type: :system do
  let(:trader) { FactoryBot.create(:user_new, admin: false) }

  before do
    login_as(trader, scope: :user)
  end

  it 'updates the balance with valid input' do
    visit balance_new_trader_path(trader)

    fill_in :init_balance, with: 500
    click_button 'Deposit'

    expect(page).to have_current_path(portfolio_trader_path(trader))
    expect(trader.reload.balance).to eq(500)
  end

  it 'displays appropriate error messages for invalid input' do
    visit balance_new_trader_path(trader)

    fill_in :init_balance, with: -100
    click_button 'Deposit'

    expect(trader.reload.balance).not_to eq(-100)
  end
end
