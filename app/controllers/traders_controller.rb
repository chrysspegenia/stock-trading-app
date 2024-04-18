class TradersController < ApplicationController
  # before_action :authorize_trader!
  
  def index
        @trader = current_user
  end

    private

  # def authorize_trader
  #     redirect_to admin_traders_path unless !current_user.admin?
  # end
end
