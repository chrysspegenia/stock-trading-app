require 'rails_helper'

RSpec.describe 'Login Authorization', type: :system do
  let(:admin_user) { FactoryBot.create(:user, admin: true) }
  let(:trader_user) { FactoryBot.create(:user_new, admin: false) }

  scenario 'Admin user is redirected to admin page after login' do
    visit new_user_session_path

    within '#login_form' do
      fill_in 'login_user_email', with: admin_user.email
      fill_in 'login_user_password', with: admin_user.password
    end

    click_button 'Login'

    within 'body', wait: 1 do
      expect(page).to have_content('Trader Accounts')
    end

    expect(page).to have_current_path(admin_traders_path)
  end

  scenario 'Trader user is redirected to trader page after login' do
    Capybara.default_max_wait_time = 60
    visit new_user_session_path

    within '#login_form' do
      fill_in 'login_user_email', with: trader_user.email
      fill_in 'login_user_password', with: trader_user.password
    end

    click_button 'Login'


    expect(page).to have_current_path(traders_path)
  end
end
