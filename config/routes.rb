Rails.application.routes.draw do
  namespace :v2 do
    get 'search' => 'search#index'
    get 'suggest' => 'search#suggest'

    resources :surahs, only: [:index, :show], defaults: { format: 'json' } do
      resources :ayahs, only: [:index], defaults: { format: 'json' }

      member do
        get :info
      end
    end

    resources :options, only: [], defaults: { format: 'json' } do
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

  scope :api do
    namespace :v3 do
      resources :chapters, only: [:index, :show], defaults: { format: 'json' } do
        member do
          get :info
        end

        resources :verses, only: [:index, :show], defaults: { format: 'json' }
      end

      resources :reciters
    end

    namespace :v2 do
      get 'search' => 'search#index'
      get 'suggest' => 'search#suggest'

      resources :surahs, only: [:index, :show], defaults: { format: 'json' } do
        resources :ayahs, only: [:index], defaults: { format: 'json' }
      end

      resources :options, only: [], defaults: { format: 'json' } do
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
end
