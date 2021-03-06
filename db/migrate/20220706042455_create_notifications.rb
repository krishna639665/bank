class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.string :message
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
