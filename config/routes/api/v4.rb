scope :v4 do

  # Chapters
  get 'chapters', to: 'chapters#index'
  get 'chapters/:id', to: 'chapters#show'

  # Chapter info
  get 'chapters/:id/info', to: 'chapter_infos#show'

  # Verses
  get 'chapters/:chapter_id/verses/random', to: 'verses#random'
  get 'verses/random', to: 'verses#random'
  get 'chapters/:chapter_id/verses', to: 'verses#index'
  get 'chapters/:chapter_id/verses/:id', to: 'verses#show'

  # Footnote
  get 'foot_notes/:id', to: 'foot_notes#show'

  # Page
  get 'pages/:id', to: 'pages#show'

  # Juz
  get 'juzs', to:  'juzs#index'
  get 'juzs/:id', to:  'juzs#show'

  resources :chapters, only: [:index, :show] do
    resources :verses, only: [:index, :show] do
      resources :translations, only: [:index]
      resources :audio_files, only: [:index]
    end
  end

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
