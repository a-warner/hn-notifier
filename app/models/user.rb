class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :saved_searches

  class << self
    def notify_new_stories
      User.find_each do |u|
        stories = u.saved_searches.inject(Set.new) do |set, search|
          matching_stories =
            search.
              matching_stories.
              where('first_seen_on_front_page_at > ?', u.last_notified_of_new_stories_at)

          set += matching_stories.to_a
          set
        end

        if stories.present?
          u.transaction do
            u.update!(last_notified_of_new_stories_at: Time.zone.now)
            HackerNewsStoryMailer.new_stories(u, stories.sort_by(&:title)).deliver
          end
        end
      end
    end
  end

  def last_notified_of_new_stories_at
    super || Time.at(0)
  end
end
