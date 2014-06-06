class PropertySite < ActiveRecord::Base
  has_many :property_site_values, dependent: :destroy
  validates :title, uniqueness: true, :presence => true
  validates :beds, numericality: true
end
