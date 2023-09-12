class AddDeletedAtToCuisines < ActiveRecord::Migration[7.0]
  def change
    add_column :cuisines, :deleted_at, :datetime
    add_index :cuisines, :deleted_at
  end
end
