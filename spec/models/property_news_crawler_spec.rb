require 'spec_helper'

describe PropertyNewsCrawler do
  it "should find a price" do
    pnewscrawl = PropertyNewsCrawler.new('http://www.propertynews.com', 'waringstown')
    pnewscrawl.findresult
    bres = pnewscrawl.parseresult("//div[contains(@class,'details col span-8 last')]")

    bres.should be_true

  end

  it "should populate the database" do
    @firstsrc = SearchParams.first
    pnewscrawl = PropertyNewsCrawler.new('http://www.propertynews.com', @firstsrc.searchparam)
    bres = pnewscrawl.findresult
    propsitecnt = PropertySite.count;
    propvalues = PropertySiteValue.count;
    expect(propsitecnt).to be > 0
    expect(propvalues).to be > 0
   end

end
