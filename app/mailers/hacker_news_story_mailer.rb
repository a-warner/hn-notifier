class HackerNewsStoryMailer < ActionMailer::Base
  default from: "hello@#{ENV.fetch('CANONICAL_DOMAIN')}"

  def new_stories(user, stories)
    @stories = stories

    mail to: user.email, subject: 'New stories matched your saved search'
  end
end
