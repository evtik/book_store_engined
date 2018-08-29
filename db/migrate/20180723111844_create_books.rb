class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.string :title
      t.text :description
      t.integer :year
      t.integer :width
      t.integer :height
      t.integer :thickness
      t.decimal :price, precision: 5, scale: 2
      t.json :main_image
      t.json :images
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
