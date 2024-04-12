class UpdateApprovedDefaultInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :approved, from: nil, to: false
  end
end
