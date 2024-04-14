class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  validates :quantity, numericality: { greater_than: 0 }
  validates :price, numericality: { greater_than: 0 }

  # after_create :update_portfolio

  # def update_portfolio
  #   if action == "buy"
  #     stock.quantity += quantity
  #   elsif action == "sell"
  #     stock.quantity -= quantity
  #   end

  #   stock.average_price = calculate_average_price
  #   stock.save
  # end

  # private

  # def calculate_average_price
  #   if action == "buy"
  #     new_total_cost = (stock.average_price * stock.quantity) + (price * quantity)
  #     new_total_quantity = stock.quantity + quantity
  #   elsif action == "sell"
  #     new_total_cost = (stock.average_price * stock.quantity) - (price * quantity)
  #     new_total_quantity = stock.quantity - quantity
  #   end

  #   new_average_price = new_total_cost / new_total_quantity.to_f
  #   new_average_price.round(2)
  # end
end
