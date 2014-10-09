class HackerNewsStory < ActiveRecord::Base
  validates :hn_id, :story_url, :title, :first_seen_on_front_page_at, presence: true

  scope :recent_first, -> { order(first_seen_on_front_page_at: :desc) }

  class << self
    def scrape
      HackerNews.new.latest_hn_stories.each do |attrs|
        where(hn_id: attrs[:hn_id]).first_or_create! do |s|
          s.first_seen_on_front_page_at = Time.zone.now
          s.attributes = attrs
        end
      end
    end
    handle_asynchronously :scrape, :priority => 1

    private

    def full_text_search(raw_tsquery)
      select("#{table_name}.*, ts_rank_cd(#{table_name}.full_text_search, query) rank").
      from("#{table_name}, #{raw_tsquery} query").
      where("query @@ #{table_name}.full_text_search").
      order('rank desc')
    end
  end

  scope :search, ->(query) do
    full_text_search("plainto_tsquery(#{connection.quote(query)})")
  end

  scope :matching_any_term, ->(terms) do
    ts_query_matching_any_term = terms.map { |t|
      "plainto_tsquery(#{connection.quote(t)})::text"
    }.join(%{ || ' | ' || })

    full_text_search(%{to_tsquery(#{ts_query_matching_any_term})})
  end

  scope :matching_user_saved_searches, ->(user) do
    matching_any_term(user.saved_searches.map(&:query))
  end

  def comments_url
    "//news.ycombinator.com/item?id=#{hn_id}"
  end
end
