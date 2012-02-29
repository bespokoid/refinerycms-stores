class CreateOrdersLineItems < ActiveRecord::Migration

  def up
    create_table :refinery_line_items do |t|
      t.references :order
      t.references :product
      t.integer    :quantity
      t.float      :unit_price, :default => 0.0, :limit => 10, :null => false

      t.timestamps
    end
    add_index  :refinery_line_items, :order_id
    add_index  :refinery_line_items, :product_id
  end

  def down
    drop_table :refinery_line_items
  end

end
