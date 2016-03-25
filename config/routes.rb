Rails.application.routes.draw do


  namespace :content do
    get 'tafsir/:id', to: 'tafsir#show'
  end

  get 'search', to: 'search#query'
  get 'suggest', to: 'suggest#query'

  post 'support', to: 'support#zendesk'

  resources :options, only: [], defaults: { format: 'json' } do
    collection do
      get :default
      get :language
      get :quran
      get :content
      get :audio
    end
  end

  resources :surahs, only: [:index, :show], defaults: { format: 'json' } do
      resources :ayat, only: [:index], defaults: { format: 'json' }
  end

  resources :pages, only: [:index]
end
