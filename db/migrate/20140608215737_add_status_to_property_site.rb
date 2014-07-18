class AddStatusToPropertySite < ActiveRecord::Migration
  def change
    add_column :property_sites, :status, :string
    add_column :property_sites, :solddate, :date
  end
end
