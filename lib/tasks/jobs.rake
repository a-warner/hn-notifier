namespace :jobs do
  desc 'Run a one-off worker which runs the latest jobs'
  task :run_latest => :environment do |t|
    Delayed::Worker.new.work_off
  end
end
