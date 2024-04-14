class ChangeSharesToShareInStocks < ActiveRecord::Migration[7.1]
  def change
    def change
      rename_column :stocks, :shares, :share
    end
  end
end
