class HackerNews
  BASE_URI = 'https://hacker-news.firebaseio.com/v0'
  NUM_STORIES_ON_FRONT_PAGE = 30

  def latest_hn_stories
    paths = top_story_ids.first(NUM_STORIES_ON_FRONT_PAGE).map { |id| "/item/#{id}.json" }
    get_all(paths).map do |story|
      {
        story_url: story['url'],
        title: story['title'],
        hn_id: story['id']
      }
    end
  end

  def top_story_ids
    get '/topstories.json'
  end

  def get(path)
    get_all([path]).first
  end

  def hn_api_path(path)
    File.join(BASE_URI, path)
  end

  def get_path(path)
    Typhoeus::Request.new(hn_api_path(path), followlocation: true)
  end

  def get_all(paths)
    requests = paths.map { |path| get_path(path).tap { |r| hydra.queue(r) } }

    hydra.run

    requests.map { |request| JSON.parse(request.response.body) }
  end

  def hydra
    @hydra ||= Typhoeus::Hydra.new
  end
end
