class AddResultTextToResultsAnalyses < ActiveRecord::Migration
  def change
    add_column :results_analyses, :result_text,  :string
  end
end

