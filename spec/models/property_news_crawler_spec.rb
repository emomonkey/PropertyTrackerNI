require 'spec_helper'

describe PropertyNewsCrawler do
  it "should find a price" do
    @pnewscrawlp = PropertyNewsCrawler.new('http://www.propertynews.com', 'waringstown')
    bres = @pnewscrawlp.parseresult("//div[contains(@class,'details col span-8 last')]")

    expect(bres).to be_truthy

  end

  it "should populate the database" do
    @firstsrc = SearchParams.first
    @firstsrc.searchparam.should_not be_nil
    pnewscrawl = PropertyNewsCrawler.new('http://www.propertynews.com', @firstsrc.searchparam)
    bres = pnewscrawl.findresult
    propsitecnt = PropertySite.count;
    propvalues = PropertySiteValue.count;
    expect(propsitecnt).to be > 0
    expect(propvalues).to be > 0
    psvalt = PropertySite.first
    psvalt.should_not be_nil
    psvalt.property_site_values.create(:price => 99999999)
    @psval2 = PropertySite.second
    @psval2.property_site_values.create(:price => 1)
    @psval3 = PropertySite.third
    @psval3.update(status:"Sold")


    @analysisworker = AnalysisResultsWorker.new
    @analysisworker.perform

    @stypeinc = SearchType.find_by_searchtext("Biggest price increase")
    @srespinc = ResultsAnalysis.find_by_SearchTypes_id(@stypeinc.id)
    @srespinc.should_not be_nil



  end

  it "should find newest addition" do
    @stypeinc = SearchType.find_by_searchtext("Newest Additions")
    @srespadd = ResultsAnalysis.find_by_SearchTypes_id(@stypeinc.id)
    @srespadd.should_not be_nil
  end

  it "count of status sold should match count of solddate not null" do

    @psoldcnt = PropertySite.count(:conditions => "status = 'Sold'")
    expect(@psoldcnt).to be > 0
    @psolddatecnt = PropertySite.count(:conditions => "solddate is not null")
    expect(@psolddatecnt).to be == @psoldcnt
  end


  it "should find Just Sold" do
    @stypeins = SearchType.find_by_searchtext("Just Sold")
    @srespsold = ResultsAnalysis.find_by_SearchTypes_id(@stypeins.id)
    @srespsold.should_not be_nil
  end

  it "should find an average price" do
    @phistavg = PopulateNewsHistoricResults.new
    @phistavg.calculatemonthavg

    @pres = SearchType.find_by_searchtext("Historic Avg")
    @res = HistoricAnalysis.find_by_search_types_id(@pres.id)
    @res.should_not be_nil
  end

  it "should find a minimum price" do
    @phistmin = PopulateNewsHistoricResults.new
    @phistmin.calculatemonthmin
    @phis = SearchType.find_by_searchtext("Historic Min")
    @reshis = HistoricAnalysis.find_by_search_types_id(@phis.id)
    @reshis.should_not be_nil
  end

 it "should find a month vol" do
   @phistvol = PopulateNewsHistoricResults.new
   @phistvol.calculatemonthvol
   @stypetxt = SearchType.find_by_searchtext('Volume Sales')
   @reshis = HistoricAnalysis.find_by_search_types_id(@stypetxt.id)
   @reshis.should_not be_nil
 end


  it "should generate data for graph" do
    @gdata = GraphingService.new
    @vdata = @gdata.fndvolall
    @vdata.should_not be_nil
  end


  it "should find volume low level types" do
    @phistsumvol = PopulateNewsHistoricResults.new
    @phistsumvol.volumelowproptype
    @presd = SearchType.find_by_searchtext("Volume Summary Property Types")
    @resd = HistoricAnalysis.find_by_search_types_id(@presd.id)
    @resd.should_not be_nil
  end


end
