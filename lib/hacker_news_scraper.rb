class HackerNewsScraper
  def latest_hn_stories
    latest_hn_homepage.css('table table')[1].css('tr').each_slice(3).map do |title_row, subtext_row, _|
      next if subtext_row.css('a[href="news?p=2"]').present?

      story_link = title_row.css('td.title a').first
      item_permalink = subtext_row.css('a[href*="item"]').first['href']
      hn_id = Rack::Utils.parse_nested_query(URI.parse(item_permalink).query)['id']

      {
        story_url: story_link['href'],
        title: story_link.text,
        hn_id: hn_id
      }
    end.compact
  end

  def latest_hn_homepage
    Nokogiri::HTML.parse(mechanize_client.get('https://news.ycombinator.com/news').body)
  end

  def mechanize_client
    @client ||= Mechanize.new do |a|
      a.user_agent_alias = 'Mac Safari'
    end
  end
end