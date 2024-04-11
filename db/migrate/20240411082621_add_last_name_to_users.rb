class AddLastNameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :last_name, :boolean, default: false
  end
end
