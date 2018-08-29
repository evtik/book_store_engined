class CreateJoinTableAuthorsBooks < ActiveRecord::Migration[5.1]
  def change
    create_join_table :authors, :books do |t|
      t.index [:book_id, :author_id]
    end
  end
end
