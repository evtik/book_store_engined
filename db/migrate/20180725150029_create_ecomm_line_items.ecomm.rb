# This migration comes from ecomm (originally 20180515184655)
class CreateEcommLineItems < ActiveRecord::Migration[5.1]
  def change
    create_table :ecomm_line_items do |t|
      t.integer :product_id
      t.integer :order_id
      t.integer :quantity

      t.timestamps
    end
    add_index :ecomm_line_items, :product_id
    add_index :ecomm_line_items, :order_id

    add_foreign_key :ecomm_line_items, :ecomm_orders, column: :order_id
  end
end
