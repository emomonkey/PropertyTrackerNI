class PropertyNewsCrawler
  include CrawlerModule
  attr_reader :url, :searchinput, :searchtag, :pageresults
  PARSELN_CONST = "//div[contains(@class,'details col span-8 last')]"

  def initialize(url, searchinput)
    @url = url
    @searchinput = searchinput

    initializecw
    navigatecw(url, searchinput)
  rescue StandardError => e
    Rails.logger.debug 'Error running PropertyNewsCrawler.initialize ' + e.message

  end

  def parseresult(srcxpath)
    bfound = false
    currpage = pullxpath(srcxpath)
    currpage.each do |spage|
      sbeds = spage["beds"]

      propertysite = PropertySite.find_by :title => spage["itmtitle"]

     if propertysite.nil?
        propertysite = PropertySite.create(:title => spage["itmtitle"], :propertytype => spage["type"], :beds => sbeds.to_i, :searchtext => @searchinput, :status => spage["status"], :lastdatescanned => DateTime.now )
        vsearch = SearchParams.where("searchparam = ?", @searchinput).first
        vsearch.update(searchdate: DateTime.now)
      else
        if (propertysite.status != "Sold" or propertysite.status !="Sale Agreed") and propertysite.status != spage["status"]
          propertysite.update(:status => spage["status"], :lastdatescanned => DateTime.now)
          vsearch = SearchParams.where("searchparam = ?", @searchinput).first
          vsearch.update(searchdate: DateTime.now)
        else
          propertysite.update(:lastdatescanned => DateTime.now)
          vsearch = SearchParams.where("searchparam = ?", @searchinput).first
          vsearch.update(searchdate: DateTime.now)
        end
      end
 #     propertysite = PropertySite.find_by title: spage["itmtitle"]
      bfound = true
      scurrval = spage["itmprice"]
      spos = scurrval.index("£")
      unless spos.nil?
         sprice = scurrval[spos+1..-1]
         iprice = sprice.delete(',').to_i
         unless propertysite.property_site_values.exists?(:price => iprice)

         #  propertysite.property_site_values.save
         #  Rails.logger.info(propertysite.id)
           propertysite.property_site_values.create(:price => iprice)
         end
      end

    end
    return bfound
  rescue StandardError => e
    Rails.logger.debug 'Error running PropertyNewsCrawler.parseresult ' + e.message
    return false;
  end

  def findresult()


    bres = parseresult("//div[contains(@class,'details col span-8 last')]")

    while nextpage do
      bres = parseresult("//div[contains(@class,'details col span-8 last')]")
    end

  rescue StandardError => e
    Rails.logger.debug 'Error running PropertyNewsCrawler.findresult ' + e.message
    return false;

  end

end