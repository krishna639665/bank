class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.string :number_encrypted
      t.string :cvv_encrypted
      t.string :pin_encrypted
      t.belongs_to :account, foreign_key: true
      t.timestamps
    end
  end
end
