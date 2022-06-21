class AddingCardIdToAcc < ActiveRecord::Migration[7.0]
  def change 
    change_table :accounts do |t|
      t.belongs_to :card
    end
  end
end
