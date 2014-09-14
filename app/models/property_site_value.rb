class PropertySiteValue < ActiveRecord::Base
  belongs_to :property_site
  validates :price, numericality => {:less_than_or_equal_to => 2000000}
end
