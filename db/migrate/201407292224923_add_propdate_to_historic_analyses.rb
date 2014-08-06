class AddPropdateToHistoricAnalyses < ActiveRecord::Migration
  def change
    add_column :historic_analyses, :propdate,  :datetime
  end
end

