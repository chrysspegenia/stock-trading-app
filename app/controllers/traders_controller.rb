require 'iex-ruby-client'

class TradersController < ApplicationController
    def index
        @trader = current_user
        @stocks = current_user.stocks.all
        @transactions = current_user.transactions.all
    end

    def add_stock
        symbol = 'AAPL' # Example stock symbol
        quote = IEX::Api::Client.new.quote(symbol)

        if quote.present?
          # Create and save the stock
          stock = Stock.new(
            name: quote.company_name,
            symbol: quote.symbol,
            share: 10, # Example quantity
            price: quote.latest_price,
            user_id: current_user.id
          )
          if stock.save
            redirect_to traders_path, notice: 'Stock successfully added. Check stock table.'
          else
            redirect_to traders_path, alert: 'Failed to save the stock.'
          end
        else
          redirect_to traders_path, alert: 'Stock symbol not found or API request failed.'
        end
      end
end
