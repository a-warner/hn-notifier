class HackerNewsStoriesController < ApplicationController
  before_filter :authenticate_user!

  expose(:hacker_news_stories) do
    scope = HackerNewsStory.recent_first
    scope = scope.search(query) if query.present?
    scope.paginate(page: params[:page])
  end

  expose(:query) { params[:q].presence }

  def index
  end

  def search
    render action: :index
  end
end
