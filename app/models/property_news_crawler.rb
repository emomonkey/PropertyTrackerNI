class PropertyNewsCrawler
  include CrawlerModule

  attr_reader :url, :searchinput, :searchtag, :pageresults

  def initialize(url, searchinput)
    @url = url
    @searchinput = searchinput

    initializecw
    navigatecw(url, searchinput)
  rescue StandardError => e
    logger.debug 'Error running PropertyNewsCrawler.initialize ' + e

  end

  def parseresult(srcxpath)
    bvalid = false
    currpage = pullxpath(srcxpath)
    currpage.each do |spage|
      sbeds = spage["beds"]
      propertysite = PropertySite.find_or_create_by(:title => spage["itmtitle"], :propertytype => spage["type"], :beds => sbeds.to_i, :searchtext => @searchinput )

      bvalid = true
      scurrval = spage["itmprice"]
      spos = scurrval.index("£")
      unless spos.nil?
         sprice = scurrval[spos+1..-1]
         iprice = sprice.delete(',').to_i
         propertysite.property_site_values.find_or_create_by(:price => iprice)
       end

    end
    return bvalid
  rescue StandardError => e
    logger.debug 'Error running PropertyNewsCrawler.parseresult ' + e
    return false;
  end

  def findresult()


    bres = parseresult("//div[contains(@class,'details col span-8 last')]")

    if nextpage
      currpage = pullxpath("//div[contains(@class,'details col span-8 last')]")
      bres = parseresult(currpage)
    end

  end

end