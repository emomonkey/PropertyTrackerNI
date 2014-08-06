class AddTitleIndexToPropertySites < ActiveRecord::Migration
  def change
    add_index :property_sites, :title,  unique: true
  end
end

