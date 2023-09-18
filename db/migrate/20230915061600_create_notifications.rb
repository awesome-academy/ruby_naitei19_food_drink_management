class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :recipient, foreign_key: {to_table: :users}
      t.string :recipient_type
      t.string :title
      t.text :content
      t.datetime :read_at

      t.timestamps
    end
  end
end
