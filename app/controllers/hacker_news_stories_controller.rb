class HackerNewsStoriesController < ApplicationController
  before_filter :authenticate_user!

  expose(:hacker_news_stories) { HackerNewsStory.recent_first.paginate(page: params[:page]) }

  def index
  end
end
