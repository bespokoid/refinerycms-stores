class CreateOrdersOrders < ActiveRecord::Migration

  def up
    create_table :refinery_orders do |t|
      t.integer :order_number, :null => false, :unique => true
      t.references :order_customer
      t.string :order_status, :default => '', :null => false
      t.text :order_notes
      t.references :shipping_type
      t.datetime :shipped_on
      t.float :product_total, :default => 0.0, :limit => 10
      t.float :shipping_charges, :default => 0.0, :limit => 10
      t.float :tax_charges, :default => 0.0, :limit => 5
      t.string :cc_token
      t.string :cc_last4, :limit => 8
      t.string :cc_card_type, :limit => 32
      t.integer :cc_expiry_month
      t.integer :cc_expiry_year
      t.datetime :cc_purchased_on
      t.string  :cc_confirmation_id
      t.integer :position

      t.timestamps
    end
    add_index :refinery_orders, :order_customer_id
    add_index :refinery_orders, :shipping_type_id
    add_index :refinery_orders, :order_number
    add_index :refinery_orders, :order_status
  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-orders"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/orders/orders"})
    end

    drop_table :refinery_orders

  end

end
