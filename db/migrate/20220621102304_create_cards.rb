class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.string :number
      t.string :cvv
      t.string :pin
      t.belongs_to :account, foreign_key: true
      t.timestamps
    end
  end
end
