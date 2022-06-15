class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :transaction_id
      t.string :transaction_type
      t.string :transaction_status
      t.float :transaction_amount
      t.references :account, foreign: true

      t.timestamps
    end
  end
end
