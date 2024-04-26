require 'rails_helper'

RSpec.describe 'Trader Authentication', type: :system do
  let(:trader_user) { FactoryBot.create(:user) }

  it 'allows a trader user to log in', js: true do
  end
end
