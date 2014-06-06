require 'spec_helper'

describe PropertySite do
  it "validates the presense of title" do
    psite = PropertySite.new(:title => "Test Site")
    psite.valid?.should be_false

  end


  it "validates the saving of Property Site" do
    psite = PropertySite.create(:title => "Test Site", :beds => 0)
    psite.errors.each{|attr,msg| puts "#{attr} - #{msg}" }
    psite.valid?.should_not be_false


  end

  it "validates the blocking of duplicate Property Site Entries" do
    psite = PropertySite.create(:title => "Test Site")
    psite.valid?.should_not be_true
  end


  it  "validates the creation of a linked Property Site Value for a Property Site" do
    psite = PropertySite.find_or_create_by(:title => "Test SiteVALUE", :beds => 0)
    psite.property_site_values.create(:price => 100)
  end

end
