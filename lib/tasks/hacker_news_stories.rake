namespace :stories do
  desc 'Scrape new stories on the front page'
  task :scrape => :environment do |t|
    HackerNewsStory.scrape
  end
end
