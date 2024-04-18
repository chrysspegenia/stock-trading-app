require 'iex-ruby-client'

class TradersController < ApplicationController
  before_action :authorize_trader
  SYMBOL_NAMES = ['AAPL', 'GOOGL', 'MSFT', 'META', 'AMZN', 'TSLA'].freeze

  def index
        @trader = current_user
        # @stocks = current_user.stocks.all
        # @transactions = current_user.transactions.all
        @quotes = get_quotes(SYMBOL_NAMES)
    end

    private

    def initialize_iex_client
       @iex_client ||= IEX::Api::Client.new
    end

    def get_quotes(symbols)
        logos = get_logos(symbols)
        quotes = symbols.map { |symbol| initialize_iex_client.quote(symbol) }

        quotes.map do |quote|
          logo = logos[quote.symbol]
          {
            logo: logo,
            name: quote.company_name,
            symbol: quote.symbol,
            market_cap: quote.market_cap,
            price: quote.latest_price,
            change: quote.change,
            percent_change: quote.change_percent
          }
        end
    end

    def get_logos(symbols)
      logos = {}
      symbols.each do |symbol|
        logo = initialize_iex_client.logo(symbol)
        logos[symbol] = logo.url if logo.present?
      end
      logos
    end

  def authorize_trader
      redirect_to admin_traders_path unless !current_user.admin?
  end
end
