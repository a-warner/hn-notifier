Rails.application.routes.draw do
  devise_for :users
  root to: 'static#index'

  resources :saved_searches, :only => %w(index new create destroy)
  resources :hacker_news_stories, :only => %w(index)
end
