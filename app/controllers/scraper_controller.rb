class ScraperController < ApplicationController
  def search
    @ivar = "test"
    @pnewscrawl = PropertyNewsCrawler.new('http://www.propertynews.com', 'waringstown')
    @ivar2 = "test2"
    @pnewscrawl.find
  end

  def result
  end
end
