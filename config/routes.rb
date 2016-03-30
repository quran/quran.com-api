Rails.application.routes.draw do

  namespace :v2 do
    resources :surahs, only: [:index, :show], defaults: { format: 'json' } do
      resources :ayahs, only: [:index], defaults: { format: 'json' }
    end
  end

  namespace :content do
    get 'tafsir/:id', to: 'tafsir#show'
  end

  get 'search', to: 'search#query'
  get 'suggest', to: 'search#suggest'

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
