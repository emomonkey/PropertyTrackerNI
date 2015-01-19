# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every 1.month, :at => 'start of the month at 6:53pm' do
   runner "ParseResultsWorker.perform_async"
end

every 1.month,  :at => 'start of the month at 11:54pm' do
   runner "AnalysisResultsWorker.perform_async"
end

every :sunday, :at => '12pm' do
   runner "ScheduledEmailWorker.perform_async" 
end

#AnalysisResultsWorker.perform_in(1.minutes, 10000)
