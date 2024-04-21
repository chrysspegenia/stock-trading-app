class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  def self.create_transaction(user, stock, quantity, price, action, total_amount)
    new(
      user: user,
      stock: stock,
      quantity: quantity,
      price: price,
      action: action,
      total_amount: total_amount
    )
  end
end
