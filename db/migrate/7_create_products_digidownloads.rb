class CreateProductsDigidownloads < ActiveRecord::Migration

  def up
    create_table :refinery_digidownloads do |t|
      t.references :product, :null => false
      t.string    :download_token, :unique => true, :null => false
      t.integer   :download_completed, :default => 0
      t.integer   :download_remaining, :default => 0
      t.integer   :download_count,     :default => 0
      t.integer   :restrict_count
      t.datetime  :restrict_date
      t.boolean   :is_defunct,         :default => false

      t.string    :doc_file_name
      t.string    :doc_content_type
      t.integer   :doc_file_size
      t.datetime  :doc_updated_at

      t.string    :preview_file_name
      t.string    :preview_content_type
      t.integer   :preview_file_size
      t.datetime  :preview_updated_at

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
