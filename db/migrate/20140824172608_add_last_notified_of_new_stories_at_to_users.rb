class AddLastNotifiedOfNewStoriesAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_notified_of_new_stories_at, :datetime
  end
end
