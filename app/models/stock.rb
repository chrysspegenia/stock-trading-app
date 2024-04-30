require 'iex-ruby-client'
class Stock < ApplicationRecord
  belongs_to :user
  has_many :transactions

  validates :shares, numericality: { greater_than_or_equal_to: 0 }

  def self.create_or_update_stock(symbol, user, company_name)
    stock = find_or_initialize_by(symbol: symbol, user_id: user.id)
    stock.name = company_name
    stock.user = user unless stock.persisted?
    stock.save
    stock
  end

  def self.update_portfolio(stock, quantity, price)
    stock.price = price
    stock.shares += quantity
    stock.latest_price = price
    stock.save

    stock.current_value = stock.shares * stock.price
    stock.save

    stock.price_per_share = calculate_price_per_share(stock.current_value, stock.shares)
    stock.save
  end

  # Updates the price in the Stock from iex every 30 minutes. Has used Whenever Gem and Crontab
  def self.update_latest_prices
    all.each do |stock|
      quote = initialize_iex_client_quote(stock.symbol)
      latest_price = BigDecimal(quote.latest_price.to_s)
      current_value = calculate_current_value(latest_price, stock.shares)
      price_per_share = calculate_price_per_share(current_value, stock.shares)
      stock.update(latest_price: latest_price, current_value: current_value, price_per_share: price_per_share)
    end
  end
  
  def self.fetch_chart_data(iex_client, ticker_symbol)
    historical_prices = iex_client.historical_prices(ticker_symbol, {range: "6m"})
    latest_market_price = iex_client.market[ticker_symbol]
    today = Date.today

    historical_data = historical_prices.map do |entry| 
      [(entry.date).to_s, [entry.open, entry.close, entry.low, entry.high]] 
    end

    # historical_data << [today.to_s, [latest_market_price.open.price,
    #                                   latest_market_price.close.price,
    #                                   latest_market_price.low,
    #                                   latest_market_price.high]]
    historical_data.to_h
end


  private

  def self.initialize_iex_client_quote(symbol)
    IEX::Api::Client.new.quote(symbol)
  end

  def self.calculate_current_value(latest_price, shares)
    latest_price * shares
  end

  def self.calculate_price_per_share(current_value, shares)
    if current_value.positive? && shares.positive?
      current_value / shares
    else
      0.0
    end
  end
end
