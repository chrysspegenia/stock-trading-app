class AddTotalAmountToTransactions < ActiveRecord::Migration[7.1]
  def change
    add_column :transactions, :total_amount, :decimal, default: 0.0
  end
end
