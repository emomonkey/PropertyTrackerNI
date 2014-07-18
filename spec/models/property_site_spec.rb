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

  it "should validate the setting of sold date on an insert" do
    psite = PropertySite.create(:title => "Test Sold Date", :status => "Sale Agreed", :beds => 0)
    psite.solddate.should_not be_nil

  end

  it "should validate the setting of sold date on an update" do
    pupd = PropertySite.find_by(:title => "Test Site")
    pupd.update(:status => "Sale Agreed")
    pup = PropertySite.find_by(:title => "Test Site")
    pup.solddate.should_not be_nil

  end




end
