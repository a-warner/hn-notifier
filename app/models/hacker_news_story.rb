class HackerNewsStory < ActiveRecord::Base
  validates :hn_id, :story_url, :title, :first_seen_on_front_page_at, presence: true

  class << self
    def scrape
      HackerNewsScraper.new.latest_hn_stories.each do |attrs|
        where(hn_id: attrs[:hn_id]).first_or_create! do |s|
          s.first_seen_on_front_page_at = Time.zone.now
          s.attributes = attrs
        end
      end
    end
    handle_asynchronously :scrape
  end
end
