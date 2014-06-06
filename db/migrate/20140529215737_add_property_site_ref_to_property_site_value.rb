class AddPropertySiteRefToPropertySiteValue < ActiveRecord::Migration
  def change
    add_reference :property_site_values, :propertysite, index: true
  end
end
