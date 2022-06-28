class AddStatusColumnToAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :status, :boolean, :default => false
  end
end
