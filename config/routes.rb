Rails.application.routes.draw do
  scope :api do
    namespace :v3 do
      resources :chapters, only: [:index, :show], defaults: {format: 'json'} do
        member do
          get :info, to: 'chapter_infos#show'
        end

        resources :verses, only: [:index, :show], defaults: {format: 'json'} do
          resources :tafsirs, only: [:index], defaults: {format: 'json'}
        end
      end

      namespace :options, defaults: {format: 'json'} do
        get :default
        get :translations
        get :recitations
        get :tafsirs
        get :languages
        get :media_content
        get :chapter_info
      end
    end

    namespace :v2 do
      get 'search' => 'search#index'
      get 'suggest' => 'search#suggest'

      resources :surahs, only: [:index, :show], defaults: {format: 'json'} do
        resources :ayahs, only: [:index], defaults: {format: 'json'}
        resources :ayahs, only: [:index], defaults: { format: 'json' }

        member do
          get :info
        end
      end

      resources :options, only: [], defaults: {format: 'json'} do
        collection do
          get :default
          get :language
          get :quran
          get :content
          get :audio
        end
      end

      resources :pages, only: [:show]
    end
  end

  namespace :v2 do
    get 'search' => 'search#index'
    get 'suggest' => 'search#suggest'

    resources :surahs, only: [:index, :show], defaults: {format: 'json'} do
      resources :ayahs, only: [:index], defaults: {format: 'json'}

      member do
        get :info
      end
    end

    resources :options, only: [], defaults: {format: 'json'} do
      collection do
        get :default
        get :language
        get :quran
        get :content
        get :audio
      end
    end

    resources :pages, only: [:show]
  end

  namespace :content do
    get 'tafsir/:id', to: 'tafsir#show'
  end

  get 'search', to: 'search#query'
  get 'suggest', to: 'search#suggest'

  resources :options, only: [], defaults: {format: 'json'} do
    collection do
      get :default
      get :language
      get :quran
      get :content
      get :audio
    end
  end

  root to: 'ping#ping'
  get '/ping', to: 'ping#ping'
end
