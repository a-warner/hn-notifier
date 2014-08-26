Rails.application.routes.draw do
  devise_for :users
  root to: 'static#index'

  resources :saved_searches, :only => %w(index new create destroy)
  resources :hacker_news_stories, :only => %w(index)

  get :search, to: 'hacker_news_stories#search'

  constraints ->(request) { request.env['warden'].authenticate? && request.env['warden'].user.admin? } do
    match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]
  end
end
