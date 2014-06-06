class CreatePropertySiteValues < ActiveRecord::Migration
  def change
    create_table :property_site_values do |t|
      t.integer :property_site_id
      t.integer :price

      t.timestamps
    end
  end
end
