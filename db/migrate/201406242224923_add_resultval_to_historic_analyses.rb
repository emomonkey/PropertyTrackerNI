class AddResultvalToHistoricAnalyses < ActiveRecord::Migration
  def change
    add_column :historic_analyses, :resultvalue,  :integer
  end
end

