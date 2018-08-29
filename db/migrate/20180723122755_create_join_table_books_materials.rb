class CreateJoinTableBooksMaterials < ActiveRecord::Migration[5.1]
  def change
    create_join_table :books, :materials do |t|
      t.index [:book_id, :material_id]
    end
  end
end
