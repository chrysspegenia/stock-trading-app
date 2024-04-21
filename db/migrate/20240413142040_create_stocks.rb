class CreateStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :stocks do |t|
      t.string :symbol
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.integer :shares, default: 0.0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
