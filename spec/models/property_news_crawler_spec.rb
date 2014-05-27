require 'spec_helper'

describe PropertyNewsCrawler do
  it "should find a price and address" do
    @pnewscrawl = PropertyNewsCrawler.new('http://www.propertynews.com', 'waringstown')
    @pnewscrawl.find
    results = @pnewscrawl.pageresults
    results[0]["itmtitle"].should_not be_empty
    results[0]["itmprice"].should_not be_empty
  end
end
