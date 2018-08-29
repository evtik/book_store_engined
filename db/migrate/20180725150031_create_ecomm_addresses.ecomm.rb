# This migration comes from ecomm (originally 20180526112646)
class CreateEcommAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :ecomm_addresses do |t|
      t.integer :customer_id
      t.integer :order_id
      t.string :first_name
      t.string :last_name
      t.string :street_address
      t.string :city
      t.string :zip
      t.string :country
      t.string :phone
      t.string :address_type
    end

    add_index :ecomm_addresses, :customer_id
    add_index :ecomm_addresses, :order_id

    add_foreign_key :ecomm_addresses, :ecomm_orders, column: :order_id
  end
end
