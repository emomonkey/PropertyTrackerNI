class Fixcolumn < ActiveRecord::Migration
  def change
    rename_column :property_sites, :type, :propertytype
  end
end
