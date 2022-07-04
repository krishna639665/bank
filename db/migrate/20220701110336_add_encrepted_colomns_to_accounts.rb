class AddEncreptedColomnsToAccounts < ActiveRecord::Migration[7.0]
  def change
    change_table :accounts do |t|
      t.string :account_number_encrypted
      t.string :account_ifsc_encrypted
      t.string :phone_number_encrypted
      t.string :adhar_number_encrypted
    end
  end
end
