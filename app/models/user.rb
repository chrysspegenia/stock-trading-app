class User < ApplicationRecord
  has_many :stocks
  has_many :transactions

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  attr_accessor :unconfirmed_email
  validates :first_name, :last_name, :email, presence: {message: "Field should not be blank"}

  def self.update_balance(user, action, total_amount)
    if action == "buy"
      user.balance -= total_amount
    elsif action == "sell"
      user.balance += total_amount
    end

    user.save
  end

end
