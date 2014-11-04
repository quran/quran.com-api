Rails.application.routes.draw do

  namespace :content do
    get 'tafsir/:id', to: "tafsir#show"
  end

  get "search", to: 'search#query'

  namespace :info do
    resources :surahs
  end

  resources :options do
    collection do 
      get :default
      get :language
      get :quran
      get :content
      get :audio
    end
  end

  namespace :bucket do
      resources :ayat
  end

  
  
end
