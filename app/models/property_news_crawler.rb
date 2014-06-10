class PropertyNewsCrawler
  include CrawlerModule

  attr_reader :url, :searchinput, :searchtag, :pageresults

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

#      unless PropertySite.exists?(:title => spage["itmtitle"])
     if propertysite.nil?
        propertysite = PropertySite.create(:title => spage["itmtitle"], :propertytype => spage["type"], :beds => sbeds.to_i, :searchtext => @searchinput, :status => spage["status"] )
      else
        if propertysite.status != "Sold" and property_site.status != spage["status"]
          propertysite.update(:status => spage["status"])
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

           propertysite.property_site_values.save
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

    if nextpage
      currpage = pullxpath("//div[contains(@class,'details col span-8 last')]")
      bres = parseresult(currpage)
    end

  end

end