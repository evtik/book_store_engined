# This migration comes from ecomm (originally 20180514201826)
class CreateEcommShipments < ActiveRecord::Migration[5.1]
  def change
    create_table :ecomm_shipments do |t|
      t.string :method
      t.integer :days_min
      t.integer :days_max
      t.decimal :price, precision: 5, scale: 2
    end
  end
end
