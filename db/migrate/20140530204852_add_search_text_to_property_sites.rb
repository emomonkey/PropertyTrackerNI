class AddSearchTextToPropertySites < ActiveRecord::Migration
  def change
    add_column :property_sites, :searchtext,  :string
  end
end
