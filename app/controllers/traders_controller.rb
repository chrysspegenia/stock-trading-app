class TradersController < ApplicationController
    def index
        @trader = current_user
    end
end
