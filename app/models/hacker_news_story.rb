class HackerNewsStory < ActiveRecord::Base
  validates :hn_id, :story_url, :title, :first_seen_on_front_page_at, presence: true

  scope :recent_first, -> { order(first_seen_on_front_page_at: :desc) }

  class << self
    def scrape
      HackerNewsScraper.new.latest_hn_stories.each do |attrs|
        where(hn_id: attrs[:hn_id]).first_or_create! do |s|
          s.first_seen_on_front_page_at = Time.zone.now
          s.attributes = attrs
        end
      end
    end
    handle_asynchronously :scrape, :priority => 1
  end

  scope :search, ->(query, limit: nil) do
    select("#{table_name}.*, ts_rank_cd(#{table_name}.full_text_search, query) rank").
     from("#{table_name}, plainto_tsquery(#{connection.quote(query)}) query").
    where("query @@ #{table_name}.full_text_search").
    order('rank desc').
    limit(limit)
  end

  def comments_url
    "//news.ycombinator.com/item?id=#{hn_id}"
  end
end
