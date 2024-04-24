class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  validates :quantity, numericality: { greater_than_or_equal_to: 1 }

  def self.create_transaction(user, stock, quantity, price, action)
    new(
      user: user,
      stock: stock,
      quantity: quantity,
      price: price,
      action: action,
      total_amount: price * quantity
    )
  end
end
