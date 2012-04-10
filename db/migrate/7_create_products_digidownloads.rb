class CreateProductsDigidownloads < ActiveRecord::Migration

  def up
    create_table :refinery_digidownloads do |t|
      t.references :product
      t.string    :download_token, :unique => true, :null => false
      t.integer   :download_completed, :default => 0
      t.integer   :download_remaining, :default => 0
      t.integer   :download_count,     :default => 0
      t.integer   :restrict_count
      t.integer   :restrict_days
      t.boolean   :is_defunct,         :default => false

      t.has_attached_file :doc
      t.has_attached_file :preview

      t.integer :position

      t.timestamps
    end

    add_index :refinery_digidownloads, :product_id
    add_index :refinery_digidownloads, :download_token

  end

  def down

    drop_table :refinery_digidownloads

  end

end
