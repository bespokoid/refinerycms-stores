class CreateAddressesAddresses < ActiveRecord::Migration

  def up
    create_table :refinery_addresses do |t|
      t.references :customer
      t.references :order
      t.boolean :is_billing, :default => false
      t.string :first_name, :default => '', :null => false
      t.string :last_name, :default => '', :null => false
      t.string :phone
      t.string :email
      t.string :address1, :default => '', :null => false
      t.string :address2
      t.string :city
      t.string :state, :default => '', :limit => 32
      t.string :zip, :default => '', :limit => 32
      t.string :country, :default => '', :limit => 16, :null => false
      t.integer :position

      t.timestamps
    end
    add_index :refinery_addresses, :customer_id
    add_index :refinery_addresses, :order_id
    add_index :refinery_addresses, [:last_name, :first_name]
    add_index :refinery_addresses, :phone
    add_index :refinery_addresses, :email

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-addresses"})
    end

    drop_table :refinery_addresses

  end

end
