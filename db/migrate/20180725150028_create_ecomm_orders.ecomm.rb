# This migration comes from ecomm (originally 20180515141922)
class CreateEcommOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :ecomm_orders do |t|
      t.integer :customer_id
      t.integer :shipment_id
      t.integer :coupon_id
      t.string :state
      t.decimal :subtotal, precision: 6, scale: 2

      t.timestamps
    end

    add_index :ecomm_orders, :customer_id
    add_index :ecomm_orders, :shipment_id
    add_index :ecomm_orders, :coupon_id

    add_foreign_key :ecomm_orders, :ecomm_shipments, column: :shipment_id
    add_foreign_key :ecomm_orders, :ecomm_coupons, column: :coupon_id
  end
end
