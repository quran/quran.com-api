Rails.application.routes.draw do


  namespace :content do
    get 'tafsir/:id', to: 'tafsir#show'
  end

  get 'search', to: 'search#query'

  post 'support', to: 'support#zendesk'  

  resources :options do
    collection do 
      get :default
      get :language
      get :quran
      get :content
      get :audio
      get :setup_index
    end
  end

  resources :surahs do
      resources :ayat
  end

  
  
end
