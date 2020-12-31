namespace :v4 do
  get 'ping', to: 'ping#ping'

  # Chapters
  get 'chapters', to: 'chapters#index'
  get 'chapters/:id', to: 'chapters#show'

  # Chapter info
  get 'chapters/:id/info', to: 'chapter_infos#show'

  # Random verse
  get 'chapters/:chapter_id/verses/random', to: 'verses#random'
  get 'verses/random', to: 'verses#random'

  # Verse by chapter
  get 'chapters/:chapter_id/verses', to: 'verses#index'
  get 'chapters/:chapter_id/verses/:id', to: 'verses#show'

  # Verses by page number
  get 'pages/:id', to: 'pages#show'

  # Footnote
  get 'foot_notes/:id', to: 'foot_notes#show'

  # Juz
  get 'juzs', to: 'juzs#index'
  get 'juzs/:id', to: 'juzs#show'

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
