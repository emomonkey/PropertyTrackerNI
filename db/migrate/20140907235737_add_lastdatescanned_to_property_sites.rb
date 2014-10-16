class AddLastdatescannedToPropertySites < ActiveRecord::Migration
  def change
    add_column :property_sites, :lastdatescanned, :datetime
  end
end
