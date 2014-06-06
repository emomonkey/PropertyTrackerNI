class ScraperController < ApplicationController
  def search

    nosearch = SearchParams.count;

    # 25 is the number of sidekiq workers
    batchsize = 5000;
    isize = 1;
    begin
      SearchParams.find_each(start:isize, batch_size: batchsize) do |params|
      @pnewscrawl = PropertyNewsCrawler.new('http://www.propertynews.com', params.searchparam)
      @pnewscrawl.findresult
      end
      isize = isize + batchsize
    end while isize < nosearch


  end

  def result
  end
end
