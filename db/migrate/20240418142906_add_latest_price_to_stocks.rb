class AddLatestPriceToStocks < ActiveRecord::Migration[7.1]
  def change
    add_column :stocks, :latest_price, :decimal
  end
end
