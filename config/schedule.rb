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

every 10.minutes do
  command "cd /home/chad/workspace/stock-trading-app && RAILS_ENV=development /home/chad/.asdf/shims/bundle exec bin/rails runner 'Stock.update_latest_prices' >> /home/chad/workspace/stock-trading-app/log/logfile.log 2>&1"
end
