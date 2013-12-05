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
# adds ">> cron.log 2> error.log" to all commands
set :output, {:error => 'log/whenever-error.log', :standard => 'log/whenever-cron.log'}
job_type :runnerbundle,  "cd :path && bundle exec rails runner -e :environment ':task' :output"

every 2.hours do
  runnerbundle "DbEntry.gis2gi_queue"
end

every :reboot do
  runnerbundle "DbEntry.gis2gi_queue"
end
