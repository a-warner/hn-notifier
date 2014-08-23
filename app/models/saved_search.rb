class SavedSearch < ActiveRecord::Base
  belongs_to :user
  validates :query, presence: true
end
