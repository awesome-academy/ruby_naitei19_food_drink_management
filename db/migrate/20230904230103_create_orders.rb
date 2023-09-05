class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :note
      t.integer :status
      t.integer :sum

      t.timestamps
    end
  end
end
