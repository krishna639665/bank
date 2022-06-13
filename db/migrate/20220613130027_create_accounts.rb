class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.string :address
      t.integer :age
      t.string :nomine_name
      t.string :phone_number
      t.string :adhar_number
      t.string :account_type
      t.string :account_number
      t.string :account_ifsc
      t.float :account_balance
      t.references :user, foreign_key: true
    
      t.timestamps
    end
    add_index :accounts, :account_number, unique: true
  end
end
