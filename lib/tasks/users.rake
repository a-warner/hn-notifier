namespace :users do
  desc 'Notify users of new stories'
  task :notify_new_stories => :environment do |t|
    User.notify_new_stories
  end
end
