require 'mechanize'
require 'nokogiri'

module CrawlerModule

  attr_writer :agent, :data, :result_page, :items

  def initializecw
    @agent ||= Mechanize.new
  end

  def navigatecw(url, searchinput)
    @agent.get(url)
    @agent.page.forms[1]["search-box-text"] = searchinput
    @agent.page.forms[1].checkbox_with(:name =>'IncludeAgreed_checkbox').check
    @agent.page.forms[1]["IncludeAgreed"] = 1
    @result_page = @agent.page.forms[1].submit

  rescue StandardError => e
    Rails.logger.debug 'Error running crawler_module.navigatecw ' + e.message
    return false;
  end

  # parse

  def pullxpath(searchtarget)

    housecol = Array.new
    html = Nokogiri::HTML(@result_page.body)
    @items = html.xpath(searchtarget)
    @items.each do |item|
      pdetails = Hash.new


    #  unless item.css("h2").css("a")[0].nil?
      unless item.css("h2")[0].nil?
        pdetails["itmtitle"] = item.css("h2")[0].content
      end
      # Parse for currency symbol
      if item.css("h3")[0].nil?
        pdetails["itmprice"] = "£0"
      else
        pdetails["itmprice"] = item.css("h3")[0].content
      end
      if item.css(".beds")[0].nil?
        pdetails["beds"] = "0"
      else
        pdetails["beds"] = item.css(".beds")[0].content
      end
      if item.css(".property-type")[0].nil?
        pdetails["type"] = "na"
      else
        pdetails["type"] = item.css(".property-type")[0].content
      end
      if item.css(".property-status")[0].nil?
        pdetails["status"] = "na"
      else
        pdetails["status"] = item.css(".property-status")[0].content
      end

      housecol.push(pdetails)
    end
    return housecol
  end

  def nextpage
    if @agent.page.link_with(:text => 'Next',:href => /search/)
     # @result_page = @agent.page.link_with(:text => 'Next').click
      @agent.page.link_with(:text => 'Next',:href => /search/).click
      @result_page = @agent.page
      return true
    else
      return false
    end
  rescue StandardError => e
    Rails.logger.debug 'Error running ParseResult.nextpage ' + e.message
    return false;
  end



end