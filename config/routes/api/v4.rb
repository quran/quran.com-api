scope :v4 do
  get 'foot_notes/:id', to: 'foot_notes#show'
  get 'pages/:id', to: 'pages#show'

  resources :chapters, only: [:index, :show] do
    member do
      get :info, to: 'chapter_infos#show'
    end

    resources :verses, only: [:index, :show] do
      resources :tafsirs, only: [:index]
      resources :translations, only: [:index]
      resources :audio_files, only: [:index]
    end
  end

  resources :juzs, only: [:show, :index]
  resources :words, only: [:show]

  namespace :options do
    get :translations
    get :recitations
    get :tafsirs
    get :languages
    get :media_contents
    get :chapter_infos
  end

  get 'search', to: 'search#index'
  get 'suggest', to: 'suggest#index'
end
