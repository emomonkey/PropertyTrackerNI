class SearchParams < ActiveRecord::Base
  has_many :historic_analyses , :foreign_key => 'search_params_id', :class_name => "HistoricAnalysis"

  validates :searchparam, uniqueness: true, :presence => true
end
