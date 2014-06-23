class PropertySite < ActiveRecord::Base

 # attr_accessor :status
  has_many :property_site_values, dependent: :destroy
  validates :title, uniqueness: true, :presence => true
  validates :beds, numericality: true

  def searchparamval
    return SearchParams.find_by_searchparam(:searchtext)
  end

  before_update do |property_site|
    if property_site.status_was == "For Sale" and property_site.status == "Sold"
       property_site.solddate = Date.today
    end
  end

end
