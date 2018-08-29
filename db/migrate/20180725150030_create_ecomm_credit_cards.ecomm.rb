# This migration comes from ecomm (originally 20180525220328)
class CreateEcommCreditCards < ActiveRecord::Migration[5.1]
  def change
    create_table :ecomm_credit_cards do |t|
      t.string :number
      t.string :cardholder
      t.string :month_year
      t.string :cvv
      t.integer :order_id
    end

    add_index :ecomm_credit_cards, :order_id

    add_foreign_key :ecomm_credit_cards, :ecomm_orders, column: :order_id
  end
end
