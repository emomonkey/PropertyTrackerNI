

class ParseResultsWorker
  include Sidekiq::Worker

  def perform(*args)
    isize = 1
    batchsize = 10000
    stime = Time.now
    vst = stime.strftime("%H:%M:%S");
    tstat = Transstatus.find_by name: 'ParseResultsWorker', created_at: Time.now.utc.to_date

    if tstat.nil?
      tstat = Transstatus.create(:name => "ParseResultsWorker" )
    end

    Rails.logger.debug ' ParseResultsWorker start job ' + vst
    SearchParams.find_each(start:isize, batch_size: batchsize) do |params|
      tstat.update(currentparam: params.searchparam)
      @pnewscrawl = PropertyNewsCrawler.new('http://www.propertynews.com', params.searchparam)
      @pnewscrawl.findresult
    end
    etime = Time.now
    vet = etime.strftime("%H:%M:%S");
    Rails.logger.debug ' ParseResultsWorker end job ' + vet
  rescue StandardError => e
    Rails.logger.debug 'Error running ParseResultsWorker.perform ' + e.message
    return false;
  end
end