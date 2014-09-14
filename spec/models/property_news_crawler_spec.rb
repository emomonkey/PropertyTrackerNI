require 'spec_helper'

describe PropertyNewsCrawler do

  it "should run the sidekiq action" do
    psw = ParseResultsWorker.new
    psw.perform(1, 10000)
    pcnt = PropertySite.count()
    expect(pcnt).to be > 0
  end

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


    # New Withdrawn worker should go here





  end



  it "count of status sold should match count of solddate not null" do
    @psitev = PropertySite.create(:title => "Test Sale", :status => "Sale Agreed", :beds => 0)
    puts PropertySite.count()
    @psoldcnt = PropertySite.count(:conditions => "status = 'Sold'")
    expect(@psoldcnt).to be > 0
    @psolddatecnt = PropertySite.count(:conditions => "solddate is not null")
    expect(@psolddatecnt).to be == @psoldcnt
  end

  it "count of status Withdrawn should be greater than 0" do
    @psitevd = PropertySite.create(:title => "Test Sale", :status => "Sale Agreed", :beds => 0, :lastdatescanned => (Date.today - 3.months))
    PropertySite.lastscanned
    pwithcnt = PropertySite.count(:conditions => "status = 'Withdrawn'")
    expect(pwithcnt).to be > 0

  end


  it "should find an average price" do
    @prest = SearchType.find_by_searchtext("Historic Avg")
    @firstsrc = SearchParams.first
    @firstsrc.searchparam.should_not be_nil
    pnewscrawl = PropertyNewsCrawler.new('http://www.propertynews.com', @firstsrc.searchparam)
    bres = pnewscrawl.findresult
    #ScheduledProcedure.parsehistoric()
    ActiveRecord::Base.connection.execute("SELECT ab_historic_avg();")
    @res = HistoricAnalysis.find_by_search_types_id(@prest.id)
    @res.should_not be_nil
  end

  it "should find a minimum price" do
    @prest = SearchType.find_by_searchtext("Historic Avg")
    @firstsrc = SearchParams.first
    @firstsrc.searchparam.should_not be_nil
    pnewscrawl = PropertyNewsCrawler.new('http://www.propertynews.com', @firstsrc.searchparam)
    bres = pnewscrawl.findresult
    ActiveRecord::Base.connection.execute("SELECT ab_historic_min();")
    @phis = SearchType.find_by_searchtext("Historic Min")
    @reshis = HistoricAnalysis.find_by_search_types_id(@phis.id)
    @reshis.should_not be_nil
  end

 it "should find a month vol" do
   @firstsrc = SearchParams.first
   @firstsrc.searchparam.should_not be_nil
   pnewscrawl = PropertyNewsCrawler.new('http://www.propertynews.com', @firstsrc.searchparam)
   bres = pnewscrawl.findresult
   ActiveRecord::Base.connection.execute("SELECT ab_historic_cnt();")
   @stypetxt = SearchType.find_by_searchtext('Volume Summary Property Types')
   @reshis = HistoricAnalysis.find_by_search_types_id(@stypetxt.id)
   @reshis.should_not be_nil
 end


  it "should generate data for graph" do
    @gdata = GraphingService.new
    @vdata = @gdata.fndvolall
    @vdata.should_not be_nil
  end


  it "should find volume low level types over" do
    @firstsrc = SearchParams.first
    @firstsrc.searchparam.should_not be_nil
    pnewscrawl = PropertyNewsCrawler.new('http://www.propertynews.com', @firstsrc.searchparam)
    bres = pnewscrawl.findresult
    ActiveRecord::Base.connection.execute("SELECT ab_historic_cnt_ovr();")
    @presd = SearchType.find_by_searchtext("Volume Summary Property Types Overall")
    @resd = HistoricAnalysis.find_by_search_types_id(@presd.id)
    @resd.should_not be_nil
  end

  it "should find sold types" do
    @firstsrc = SearchParams.first
    @firstsrc.searchparam.should_not be_nil
    pnewscrawl = PropertyNewsCrawler.new('http://www.propertynews.com', @firstsrc.searchparam)
    bres = pnewscrawl.findresult
    ActiveRecord::Base.connection.execute("SELECT ab_historic_sld();")
    sfsold = SearchType.find_by_searchtext('Sold Summary Prop Type')

    @resld = HistoricAnalysis.find_by_search_types_id(sfsold.id)
    @resld.should_not be_nil
  end


  it "should find highest increase by county" do

    @firstsrc = SearchParams.first
    @firstsrc.searchparam.should_not be_nil
    pnewscrawl = PropertyNewsCrawler.new('http://www.propertynews.com', @firstsrc.searchparam)
    bres = pnewscrawl.findresult
    psvalt = PropertySite.last
    psvalt.should_not be_nil
    psvalt.property_site_values.create(:price => 99999999)
    ActiveRecord::Base.connection.execute("SELECT ab_historic_chg();");

    pinc = SearchType.find_by_searchtext("Highest Price Increase in Cnty")
    @respinc = HistoricAnalysis.find_by_search_types_id(pinc.id)
    @respinc.should_not be_nil
  end



end
