require 'iex-ruby-client'
class Stock < ApplicationRecord
  belongs_to :user
  has_many :transactions

  def self.create_or_update_stock(symbol, user, iex_client)
    stock = find_or_initialize_by(symbol: symbol, user_id: user.id)
    stock.name = iex_client.quote(symbol).company_name
    stock.user = user unless stock.persisted?
    stock.save
    stock
  end

  def self.update_portfolio(stock, quantity, price)
    stock.price = price
    stock.shares += quantity
    stock.current_value += quantity * price
    stock.price_per_share = calculate_price_per_share(stock.current_value, stock.shares)
    stock.latest_price = price
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
