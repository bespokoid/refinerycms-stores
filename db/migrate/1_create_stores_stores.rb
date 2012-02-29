class CreateStoresStores < ActiveRecord::Migration

  def up
    create_table :refinery_stores do |t|
      t.string :name
      t.string :meta_keywords
      t.text :description
      t.boolean :is_active
      t.integer :position

      t.timestamps
    end

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-stores"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/stores/stores"})
    end

    drop_table :refinery_stores

  end

end
