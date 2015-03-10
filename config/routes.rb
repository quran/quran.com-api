Rails.application.routes.draw do


  namespace :content do
    get 'tafsir/:id', to: 'tafsir#show'
  end

  get 'search', to: 'search#query'

  post 'support', to: 'support#zendesk'  

  resources :options, only: [] do
    collection do 
      get :default
      get :language
      get :quran
      get :content
      get :audio
    end
  end

  resources :surahs, only: [:index, :show] do
      resources :ayat, only: [:index]
  end

  resources :pages, only: [:index]
end
