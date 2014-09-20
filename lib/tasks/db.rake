namespace :db do
  def run(cmd)
    `#{cmd}`.tap do |result|
      raise "Error running #{cmd.inspect}\n#{result}\n" unless $? == 0
    end
  end

  desc 'fetch and update to the latest heroku database backup'
  task :fetch do
    run %{psql -c 'drop database if exists "hn-notifier-dev-bak"'}
    run %{psql -c 'alter database "hn-notifier-dev" rename to "hn-notifier-dev-bak"'}
    Rake::Task['db:create'].invoke
    run %{curl --silent `heroku pgbackups:url` | pg_restore --no-owner --dbname hn-notifier-dev}
  end
end
