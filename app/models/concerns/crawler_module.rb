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
    pdetails = Hash.new
    housecol = new Array()
    html = Nokogiri::HTML(@result_page.body)
    @items = html.xpath("//div[contains(@class,'details col span-8 last')]")
    @items.each do |item|
      pdetails["itmtitle"] = item.css("h2").css("a")[0].content
      pdetails["itmprice"] = item.css("h3")[0].content
      housecol.push(pdetails)
    end
    return housecol
  end



end