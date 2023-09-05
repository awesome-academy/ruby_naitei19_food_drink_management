class CreateCuisines < ActiveRecord::Migration[7.0]
  def change
    create_table :cuisines do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name
      t.string :slug
      t.text :description
      t.integer :price
      t.integer :discount, default: 0
      t.boolean :available

      t.timestamps
      t.index :slug, name: "index_cuisines_on_slug", unique: true
    end
  end
end
