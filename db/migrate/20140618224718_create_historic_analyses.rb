class CreateHistoricAnalyses < ActiveRecord::Migration
  def change
    create_table :historic_analyses do |t|
      t.integer :year
      t.integer :month
      t.references :search_types, index: true
      t.references :property_sites, index: true
      t.references :search_params, index: true
      t.string :resulttext

      t.timestamps
    end
  end
end
