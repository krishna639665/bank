class AddRevertColumnStatus < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :revert, :boolean, :default => false
  end
end
