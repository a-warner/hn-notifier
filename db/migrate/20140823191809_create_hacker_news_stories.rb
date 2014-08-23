class CreateHackerNewsStories < ActiveRecord::Migration
  def change
    create_table :hacker_news_stories do |t|
      t.integer :hn_id, :null => false
      t.string :story_url
      t.string :title

      t.datetime :first_seen_on_front_page_at, :null => false

      t.timestamps :null => false
    end

    add_index :hacker_news_stories, :hn_id, unique: true
  end
end
