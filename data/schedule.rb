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

job_type :bundle_rake,    "cd :path && RAILS_ENV=:environment bundle exec rake :task :output"

# Learn more: http://github.com/javan/whenever
every 1.day, :at => '4:00 am' do
  bundle_rake "ey_s3_backup:db"
end

every 4.day, :at => '4:05 am' do
  bundle_rake "ey_s3_backup:files"
end

#every 15.minutes, :at => '5' do
#  rake "xapian:update_index"
#end
#
#every 15.minutes do
#  rake "notify_about_finished_auctions"
#end