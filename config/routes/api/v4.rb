namespace :v4 do
  get :search, to: 'search#search'
  get :suggest, to: 'suggest#suggest'

  get :chapters, to: 'chapters#index'
  get 'chapters/:id', to: 'chapters#show'

  # Chapter info
  get 'chapters/:id/info', to: 'chapter_infos#show'

  # Juz
  get 'juzs', to: 'juzs#index'
  get 'juzs/:id', to: 'juzs#show'

  # Footnote
  get 'foot_notes/:id', to: 'foot_notes#show'

  # available resources
  namespace :resources do
    get :translations
    get 'translations/:id/info', action: 'translation_info'
    get :tafsirs
    get 'tafsirs/:id/info', action: 'tafsir_info'
    get :recitations
    get 'recitations/:id/info', action: 'recitation_info'
    get :languages
    get :chapter_infos
    get :verse_media
  end

  # routes for fetching all records of one resource.
  # i.e /v4/quran/translations/121 will send complete Clear Quran translation
  namespace :quran do
    get 'translations/:translation_id', action: 'translation'
    get :'tafsirs/:tafsir_id', action: 'tafsir'
    get :'recitations/:recitation_id', action: 'recitation'

    get :'verses/uthmani', action: 'verses_text', script: 'text_uthmani'
    get :'verses/uthmani_simple', action: 'verses_text', script: 'text_uthmani_simple'
    get :'verses/uthmani_tajweed', action: 'verses_text', script: 'text_uthmani_tajweed'
    get :'verses/indopak', action: 'verses_text', script: 'text_indopak'
    get :'verses/imlaei', action: 'verses_text', script: 'text_imlaei'
    get :'verses/imlaei_simple', action: 'verses_text', script: 'text_imlaei_simple'
    # TODO: add Qaloon and other Qira'at
  end

  # verses routes, by juz, chapter, page
  namespace :verses do
    get 'by_page/:page_number', action: 'by_page'
    get 'by_juz/:juz_number', action: 'by_juz'
    get 'by_chapter/:chapter_number', action: 'by_chapter'
    get 'random', action: 'random'
  end

  # translations routes, by juz, chapter, page
  scope 'translations/:id', controller: 'translations' do
    get 'by_page/:page_number', action: 'by_page'
    get 'by_juz/:juz_number', action: 'by_juz'
    get 'by_chapter/:chapter_number', action: 'by_chapter'
    get 'random', action: 'random'
  end

  # tafsir routes, by juz, chapter, page
  scope 'tafsirs/:id', controller: 'tafsirs' do
    get 'by_page/:page_number', action: 'by_page'
    get 'by_juz/:juz_number', action: 'by_juz'
    get 'by_chapter/:chapter_number', action: 'by_chapter'
    get 'random', action: 'random'
  end

  # recitation routes, by juz, chapter, page
  scope 'recitations/:id', controller: 'recitations' do
    get 'by_page/:page_number', action: 'by_page'
    get 'by_juz/:juz_number', action: 'by_juz'
    get 'by_chapter/:chapter_number', action: 'by_chapter'
    get 'random', action: 'random'
  end

  get 'ping', to: 'ping#ping'
end
