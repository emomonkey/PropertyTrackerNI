class AddBedsToHistoricAnalyses < ActiveRecord::Migration
  def change
    add_column :historic_analyses, :beds,  :integer
    add_column :historic_analyses, :propertytype, :string
  end
end

