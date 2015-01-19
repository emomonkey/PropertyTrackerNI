class ScheduledEmailWorker
  include Sidekiq::Worker


  def initialize()

  end

  def perform(*args)

    d = DateTime.now

    email_transaction = ExportGraphJson.new
    email_transaction.generatejson
    UserProfile.find_each do |emailuser|
      ReportMailer.displayreport( emailuser.name, email_transaction.currtrans.id).deliver
    end
  rescue StandardError => e
    Rails.logger.debug 'Error running ScheduledEmailWorker.perform ' + e.message
    return false;
  end


end
