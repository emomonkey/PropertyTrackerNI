class PropertySiteValue < ActiveRecord::Base
  belongs_to :property_site
  validates :price, numericality: true
end
