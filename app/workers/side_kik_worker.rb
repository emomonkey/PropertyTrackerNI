class SideKikWorker
  include Sidekiq::Worker

  def perform(isize, batchsize)

    SearchParams.find_each(start:isize, batch_size: batchsize) do |params|
      @pnewscrawl = PropertyNewsCrawler.new('http://www.propertynews.com', params.searchparam)
      @pnewscrawl.findresult
    end
  end
end