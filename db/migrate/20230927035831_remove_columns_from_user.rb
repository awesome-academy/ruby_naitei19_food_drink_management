class RemoveColumnsFromUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :password_digest, :string
    remove_column :users, :remember_digest, :string
    remove_column :users, :activation_digest, :string
    remove_column :users, :activation_at, :date
    remove_column :users, :reset_digest, :string
    remove_column :users, :reset_digest_at, :date
  end
end
