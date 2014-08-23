class SavedSearchesController < ApplicationController
  before_filter :authenticate_user!

  expose(:saved_searches) { current_user.saved_searches }
  expose(:saved_search, attributes: :saved_search_params)

  def index
  end

  def new
  end

  def create
    if saved_search.save
      redirect_to saved_searches_path, notice: 'Search was successfully created.'
    else
      render action: 'new'
    end
  end

  def destroy
    saved_search.destroy
    redirect_to saved_searches_url, notice: 'Search was successfully destroyed.'
  end

  private

  def saved_search_params
    params.require(:saved_search).permit(:query)
  end
end
