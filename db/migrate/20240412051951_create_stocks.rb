class CreateStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :stocks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :stock_symbol
      t.integer :shares

      t.timestamps
    end
  end
end
