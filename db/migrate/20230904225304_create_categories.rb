class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :slug, unique: true

      t.timestamps
      t.index :slug, name: "index_categories_on_slug", unique: true
    end
  end
end
