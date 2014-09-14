class AnalysisResultsWorker
  include Sidekiq::Worker

  def initialize()
   #  @popresult = PopulateResults.new
  #  @pophist = PopulateNewsHistoricResults.new
  end


  def perform()
    stime = Time.now
    vst = stime.strftime("%H:%M:%S");
    Rails.logger.debug ' AnalysisResultsWorker start job ' + vst

  #  @popresult.start

    ScheduledProcedure.parsehistoric()
    etime = Time.now
    vet = etime.strftime("%H:%M:%S");
    Rails.logger.debug ' AnalysisResultsWorker end job ' + vet
  end

end