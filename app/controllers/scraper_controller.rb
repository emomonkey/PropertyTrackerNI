class ScraperController < ApplicationController




  def search

  #  @phistavg = PopulateNewsHistoricResults.new
   # @phistavg.calculatemonthavg



  #  @psval3 = PropertySite.third
  #  @psval3.update(status:"Sold")

  #  pnewscrawl = PropertyNewsCrawler.new('http://www.propertynews.com', 'waringstown')
  #  bres = pnewscrawl.parseresult("//div[contains(@class,'details col span-8 last')]")


    nosearch = SearchParams.count;

    # 25 is the number of sidekiq workers
    batchsize = 5000;
    isize = 1;
    begin
      SearchParams.find_each(start:isize, batch_size: batchsize) do |params|
   #   @pnewscrawl = PropertyNewsCrawler.new('http://www.propertynews.com', params.searchparam)
        @pnewscrawl = PropertyNewsCrawler.new('http://www.propertynews.com', "waringstown")
      @pnewscrawl.findresult
      end
      isize = isize + batchsize
    end while isize < nosearch


  end

  def result
  end
end
