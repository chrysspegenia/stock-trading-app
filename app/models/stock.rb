class Stock < ApplicationRecord
  belongs_to :user
  has_many :transactions

  validates :symbol, presence: true
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :shares, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
