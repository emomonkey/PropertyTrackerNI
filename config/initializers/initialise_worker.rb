ParseResultsWorker.perform_in(1.minutes, 1, 10000)
#AnalysisResultsWorker.perform_in(5.hours)

#Sidekiq::Cron::Job.create( name: 'Analysis Worker', cron: '5 10 * * 1-5', klass: 'AnalysisResultsWorker')
#Sidekiq::Cron::Job.create( name: 'Parse Results Worker', cron: '5 20 * * 6', klass: 'ParseResultsWorker', args: [1, 10000])