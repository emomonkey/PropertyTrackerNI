class HistoricAnalysis < ActiveRecord::Base
  belongs_to :search_types
  belongs_to :property_sites
  belongs_to :search_params


  validates :search_types_id, :uniqueness=> { :scope => [:year, :month, :beds, :propertytype, :search_params_id]}

  scope :search_yyyymm, ->(time) { where("TO_CHAR(historic_analyses.created_at,'YYYYMM') = ?", time) }
  scope :search_restype, -> (sid){where("search_types_id = ?", sid)}
  scope :search_county, -> (vcnty){joins(:search_params).
                                   where("search_params.county = 'Co.#{vcnty}'")}


end
