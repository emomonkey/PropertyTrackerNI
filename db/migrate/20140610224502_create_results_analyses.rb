class CreateResultsAnalyses < ActiveRecord::Migration
  def change
    create_table :results_analyses do |t|
      t.references :SearchTypes, index: true
      t.integer :property_id

      t.timestamps
    end
  end
end
