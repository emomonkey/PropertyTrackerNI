require 'spec_helper'

describe PropertySite do
  it "validates the presense of title" do
    @psiten = PropertySite.new(:title => "Test Site", :beds => 0)
    @psiten.should be_valid

  end


  it "validates the saving of Property Site" do
    @psite = PropertySite.create(:title => "Test Site", :beds => 0)
    @psite.should be_valid


  end

  it "validates the blocking of duplicate Property Site Entries" do
    psite = PropertySite.create(:title => "Test Site")
    psite.should_not be_valid
  end


 # it  "validates the creation of a linked Property Site Value for a Property Site" do
 #   psite = PropertySite.find_or_create_by(:title => "Test SiteVALUE", :beds => 0)
 #   psite.property_site_values.create(:price => 100)
 # end

end
