class CreatePropertySites < ActiveRecord::Migration
  def change
    create_table :property_sites do |t|
      t.string :title
      t.string :type
      t.integer :beds

      t.timestamps
    end
  end
end
