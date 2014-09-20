class HackerNewsStoriesController < ApplicationController
  before_filter :authenticate_user!

  expose(:query) { params[:q].presence }

  def index
    @hacker_news_stories = stories
  end

  def my_stories
    @hacker_news_stories = stories.matching_user_saved_searches(current_user)
  end

  def search
    @hacker_news_stories = stories.search(query)
  end

  private

  def stories
    HackerNewsStory.recent_first.paginate(:page => params[:page])
  end
end
