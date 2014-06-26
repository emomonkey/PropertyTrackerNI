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
    @result_page = @agent.page.forms[1].submit
  end

  # parse

  def pullxpath(searchtarget)

    housecol = Array.new
    html = Nokogiri::HTML(@result_page.body)
    @items = html.xpath(searchtarget)
    @items.each do |item|
      pdetails = Hash.new
      unless item.css("h2").css("a")[0].nil?
        pdetails["itmtitle"] = item.css("h2").css("a")[0].content
      end
      # Parse for currency symbol
      if item.css("h3")[0].nil?
        pdetails["itmprice"] = "£0"
      else
        pdetails["itmprice"] = item.css("h3")[0].content
      end
      if item.css("p").css(".beds")[0].nil?
        pdetails["beds"] = "0"
      else
        pdetails["beds"] = item.css("p").css(".beds")[0].content
      end
      if item.css("p").css(".type")[0].nil?
        pdetails["type"] = "na"
      else
        pdetails["type"] = item.css("p").css(".type")[0].content
      end
      if item.css("p").css(".status")[0].nil?
        pdetails["status"] = "na"
      else
        pdetails["status"] = item.css("p").css(".status")[0].content
      end

      housecol.push(pdetails)
    end
    return housecol
  end

  def nextpage
    if @agent.page.link_with(:text => 'Next')
      @result_page = @agent.page.link_with(:text => 'Next').click
      return true
    else
      return false
    end
  rescue StandardError => e
    Rails.logger.debug 'Error running ParseResult.nextpage ' + e.message
    return false;
  end



end