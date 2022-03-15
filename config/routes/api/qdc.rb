namespace :qdc do
  namespace :qr do
    get :reflections, to: 'reflections#index'
    get 'reflections/:id', to: 'reflections#show'
    get 'reflections/:post_id/comments', to: 'comments#index'
    get 'comments/:id', to: 'comments#show'
    get 'comments/:comment_id/replies', to: 'comments#replies'
    get :tags, to: 'tags#index'
    get :authors, to: 'authors#index'
    get 'authors/:id', to: 'authors#show'
    get 'authors/:id/followers', to: 'authors#followers'
    get 'authors/:id/followings', to: 'authors#followings'
    get :search, to: 'search#search'
  end

  # available resources
  namespace :resources do
    get :translations
    get 'translations/:translation_id/info', action: 'translation_info'
    get 'translations/filter', action: 'filter'
    get :tafsirs
    get 'tafsirs/:tafsir_id/info', action: 'tafsir_info'
    get :recitation_styles
    get :languages
    get :chapter_infos
    get :verse_media
  end

  get :chapters, to: 'chapters#index'
  get 'chapters/:id', to: 'chapters#show'

  # Chapter info
  get 'chapters/:id/info', to: 'chapter_infos#show'

  # Juz
  get 'juzs', to: 'juzs#index'
  get 'juzs/:id', to: 'juzs#show'

  # Hizb
  get 'hizbs', to: 'hizbs#index'
  get 'hizbs/:id', to: 'hizbs#show'

  # Rul el hizbs
  get 'rub_el_hizbs', to: 'rub_el_hizbs#index'
  get 'rub_el_hizbs/:id', to: 'rub_el_hizbs#show'

  # Manzils
  get 'manzils', to: 'manzils#index'
  get 'manzils/:id', to: 'manzils#show'

  # Ruku
  get 'rukus', to: 'rukus#index'
  get 'rukus/:id', to: 'rukus#show'

  # Page
  get 'pages', to: 'pages#index'
  get 'pages/lookup', to: 'pages#lookup'
  get 'pages/:id', to: 'pages#show'

  # verses routes, by juz, chapter, page
  namespace :verses do
    get 'by_page/:page_number', action: 'by_page'
    get 'by_juz/:juz_number', action: 'by_juz'
    get 'by_chapter/:chapter_number', action: 'by_chapter'
    get 'by_rub_el_hizb/:rub_el_hizb_number', action: 'by_rub_el_hizb'
    get 'by_hizb/:hizb_number', action: 'by_hizb'
    get 'by_manzil/:manzil_number', action: 'by_manzil'
    get 'by_ruku/:ruku_number', action: 'by_ruku'
    get 'by_key/:verse_key', action: 'by_key'
    get :filter

    get 'random', action: 'random'
  end

  get :search, to: 'search#search'
  get :navigate, to: 'search#navigate'

  # Advance copy
  get 'verses/advanced_copy', to: 'advanced_copy#index'

  # Get footnote text
  get 'foot_notes/:id', to: 'foot_notes#show'

  # Get approved Mushafs
  get :mushafs, to: 'mushafs#index'

  namespace :audio do
    # Surah audio recitations, FE team wants to access them using /audio/reciters path instead of /audio/recitations...well sure!
    get 'reciters', to: 'recitations#index'
    get 'reciters/:reciter_id', to: 'recitations#show'
    get 'reciters/:reciter_id/audio_files', to: 'recitations#audio_files'
    get 'reciters/:reciter_id/related', to: 'recitations#related'

    # Get timestamp for ayah
    get 'reciters/:reciter_id/timestamp', to: 'recitations#timestamp'
    # Segments and percentiles
    get 'reciters/:reciter_id/lookup', to: 'recitations#lookup_ayah'

    # percentiles
    get 'reciters/:reciter_id/percentiles', to: 'recitations#cumulative_percentile'
    get 'reciters/:reciter_id/ayah_percentiles', to: 'recitations#ayah_duration_percentile'

    # Radio stations
    get 'stations', to: 'radio_stations#index'
    get 'stations/:station_id', to: 'radio_stations#show'
  end

  # routes for fetching all records of one resource.
  # i.e /qdc/quran/translations/131 will send complete Clear Quran translation
  namespace :quran do
    get 'translations/:translation_id', action: 'translation'
    get 'tafsirs/:tafsir_id', action: 'tafsir'
    get 'recitations/:recitation_id', action: 'recitation'
    get 'verses/:script', action: 'verses_text'
  end

  # translations routes, by juz, chapter, page
  scope 'translations/:resource_id', controller: 'translations' do
    get 'by_chapter/:chapter_number', action: 'by_chapter'
    get 'by_page/:page_number', action: 'by_page'
    get 'by_juz/:juz_number', action: 'by_juz'
    get 'by_rub_el_hizb/:rub_el_hizb_number', action: 'by_rub_el_hizb'
    get 'by_hizb/:hizb_number', action: 'by_hizb'
    get 'by_manzil/:manzil_number', action: 'by_manzil'
    get 'by_ruku/:ruku_number', action: 'by_ruku'
    get 'by_ayah/:ayah_key', action: 'by_ayah'
  end

  # tafsir routes, by juz, chapter, page
  scope 'tafsirs/:resource_id', controller: 'tafsirs' do
    get 'by_chapter/:chapter_number', action: 'by_chapter'
    get 'by_page/:page_number', action: 'by_page'
    get 'by_juz/:juz_number', action: 'by_juz'
    get 'by_rub_el_hizb/:rub_el_hizb_number', action: 'by_rub_el_hizb'
    get 'by_hizb/:hizb_number', action: 'by_hizb'
    get 'by_manzil/:manzil_number', action: 'by_manzil'
    get 'by_ruku/:ruku_number', action: 'by_ruku'
    get 'by_ayah/:ayah_key', action: 'by_ayah'
  end

  scope 'recitations/:recitation_id', controller: 'recitations' do
    get 'by_chapter/:chapter_number', action: 'by_chapter'
    get 'by_page/:page_number', action: 'by_page'
    get 'by_juz/:juz_number', action: 'by_juz'
    get 'by_rub_el_hizb/:rub_el_hizb_number', action: 'by_rub_el_hizb'
    get 'by_hizb/:hizb_number', action: 'by_hizb'
    get 'by_manzil/:manzil_number', action: 'by_manzil'
    get 'by_ruku/:ruku_number', action: 'by_ruku'
    get 'by_ayah/:ayah_key', action: 'by_ayah'
  end

  get 'ping', to: 'ping#ping'
  get '/', to: 'ping#ping'
end
