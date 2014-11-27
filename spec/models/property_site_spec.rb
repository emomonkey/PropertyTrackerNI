require 'spec_helper'

describe PropertySite do


  describe 'instantiation' do
   # let(:PropertySite) { Factory(:PropertySite) }
    it 'has a valid Factory' do
      @psiten = FactoryGirl.create(:PropertySite).should be_valid
    end

  end

  it "validates the presense of Created Item" do
    @psiteb = FactoryGirl.create(:PropertySite).should be_valid
    @psiteb.should be_truthy
  end

  it "validates the presense of propertyvalues" do
    @psitec = FactoryGirl.create(:PropertySite)

    @pvalues = @psitec.property_site_values.create(price:20000)

    puts @pvalues.price
    @pvalues.price.should equal(20000)
  end

  it "validates the saving of Property Site" do
    @psite = PropertySite.create(:title => "Test Site 2", :beds => 0)
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
    psite = PropertySite.create(:title => "Test Site", :beds => 0)
    pupd = PropertySite.find_by(:title => "Test Site")
    pupd.update(:status => "Sale Agreed")
    pup = PropertySite.find_by(:title => "Test Site")
    pup.solddate.should_not be_nil

  end




end
