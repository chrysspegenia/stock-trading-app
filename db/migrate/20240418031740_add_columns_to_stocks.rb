class AddColumnsToStocks < ActiveRecord::Migration[7.1]
  def change
    add_column :stocks, :price_per_share, :decimal, default: 0.0
    add_column :stocks, :current_value, :decimal, default: 0.0
  end
end
