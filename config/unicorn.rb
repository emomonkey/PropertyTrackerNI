worker_processes 4
working_directory "/var/www/PropertyTrackerNI"
pid "/var/www/PropertyTrackerNI" + "/tmp/pids/unicorn.pid"
stderr_path "/var/www/PropertyTrackerNI" + "/log/unicorn.log"
stdout_path "/var/www/PropertyTrackerNI" + "/log/unicorn.log"

listen "/var/www/PropertyTrackerNI" + '/tmp/unicorn.PropertyTrackerNI.sock', backlog: 64
listen(3000, backlog: 64) if ENV['RAILS_ENV'] == 'development'

timeout 300

# Load the app up before forking.
preload_app true

# Garbage collection settings.
GC.respond_to?(:copy_on_write_friendly=) &&
  GC.copy_on_write_friendly = true

# If using ActiveRecord, disconnect (from the database) before forking.
before_fork do |server, worker|
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.connection.disconnect!
end

# After forking, restore your ActiveRecord connection.
after_fork do |server, worker|
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.establish_connection
end
