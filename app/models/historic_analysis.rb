class HistoricAnalysis < ActiveRecord::Base
  belongs_to :search_types
  belongs_to :property_sites
  belongs_to :search_params


  validates :search_types_id, :uniqueness=> { :scope => [:year, :month, :beds, :propertytype, :search_params_id]}




end
