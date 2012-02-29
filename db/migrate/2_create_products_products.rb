class CreateProductsProducts < ActiveRecord::Migration

  def up
    create_table :refinery_products do |t|
      t.references :store, :null => false
      t.string :name
      t.string :code, :unique => true, :null => false
      t.text :description
      t.datetime :date_available
      t.integer :quantity
      t.float :price
      t.float :size_width
      t.float :size_height
      t.float :size_depth
      t.float :weight
      t.references :tax_type
      t.references :digital_download
      t.references :main_pic
      t.boolean :inactive, :default => false
      t.integer :position

      t.timestamps
    end

    add_index :refinery_products, :store_id
    add_index :refinery_products, :code
    add_index :refinery_products, :tax_type_id

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-products"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/products/products"})
    end

    drop_table :refinery_products

  end

end
