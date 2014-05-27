class PropertyNewsCrawler
  include CrawlerModule

  attr_reader :url, :searchinput, :searchtag, :pageresults

  def initialize(url, searchinput)
    @url = url
    @searchinput = searchinput

    initializecw
    navigatecw(url, searchinput)

  end


  def find
    @pageresults = pullxpath("searchtarget")
  end





end