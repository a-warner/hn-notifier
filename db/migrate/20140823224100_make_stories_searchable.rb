class MakeStoriesSearchable < ActiveRecord::Migration
  def up
    add_column :hacker_news_stories, :full_text_search, :tsvector

    execute <<-SQL
    CREATE INDEX hacker_news_stories_full_text_search_idx ON hacker_news_stories USING gin(full_text_search);

    UPDATE hacker_news_stories SET full_text_search =
      setweight(to_tsvector('pg_catalog.english', title), 'A');

    CREATE FUNCTION hacker_news_stories_trigger() RETURNS trigger AS $$
    begin
      new.full_text_search :=
        setweight(to_tsvector('pg_catalog.english', new.title), 'A');
      return new;
    end
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER hacker_news_stories_full_text_search_trigger BEFORE INSERT OR UPDATE
                ON hacker_news_stories FOR EACH ROW EXECUTE PROCEDURE hacker_news_stories_trigger();
    SQL

    change_column :hacker_news_stories, :full_text_search, :tsvector, null: false
  end

  def down
    execute <<-SQL
    DROP TRIGGER hacker_news_stories_full_text_search_trigger ON hacker_news_stories;
    DROP FUNCTION hacker_news_stories_trigger();
    SQL

    remove_column :hacker_news_stories, :full_text_search
  end
end
