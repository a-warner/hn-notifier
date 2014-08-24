class SavedSearch < ActiveRecord::Base
  belongs_to :user
  validates :query, presence: true

  def matching_stories
    HackerNewsStory.search(query)
  end
end
