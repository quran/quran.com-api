namespace :qdc do
  namespace :audio do
    # https://quranicaudio.com/api/surahs
    # https://quranicaudio.com/api/surahs/1

    # Surah audio
    get 'reciters', to: 'chapter_recitations#reciters'
    get 'reciter/:reciter_id', to: 'chapter_recitations#reciter_audio_files'

    # Get timestamp
    get 'reciter/:reciter_id/timestamp', to: 'segments#timestamp'

    # Segments and percentiles
    get 'reciter/:reciter_id/lookup', to: 'segments#lookup_ayah'
    get 'reciter/:reciter_id/percentiles', to: 'percentiles#cumulative_percentile'
    get 'reciter/:reciter_id/ayah_percentiles', to: 'percentiles#ayah_duration_percentile'

    # QuanicAudio api routes
    get :qaris, to: 'recitations#index'
    get 'qaris/:recitation_id', to: 'recitations#show'
    get 'qaris/related/:recitation_id', to: 'recitations#related'
    get 'qaris/:recitation_id/audio_files/:ext', to: 'recitations#audio_files'
    get :sections, to: 'sections#index'
    get :surahs, to: 'chapters#index'
    get '/surahs/:id', to: 'chapters#show'
  end

  get :search, to: 'search#search'
  get :suggest, to: 'suggest#suggest'

  get :chapters, to: 'chapters#index'
  get 'chapters/:id', to: 'chapters#show'

  # Chapter info
  get 'chapters/:id/info', to: 'chapter_infos#show'

  # Juz
  get 'juzs', to: 'juzs#index'
  get 'juzs/:id', to: 'juzs#show'

  # Advance copy
  get 'verses/advanced_copy', to: 'advanced_copy#index'

  # Footnote
  get 'foot_notes/:id', to: 'foot_notes#show'

  # available resources
  namespace :resources do
    get :translations
    get 'translations/:translation_id/info', action: 'translation_info'
    get 'translations/filter', action: 'filter'
    get :tafsirs
    get 'tafsirs/:tafsir_id/info', action: 'tafsir_info'
    get :recitations
    get 'recitations/:recitation_id/info', action: 'recitation_info'
    get :recitation_styles
    get :languages
    get :chapter_infos
    get :verse_media
    get :chapter_reciters
  end

  # routes for fetching all records of one resource.
  # i.e /v4/quran/translations/131 will send complete Clear Quran translation
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
    get :'verses/code_v1', action: 'verses_text', script: 'code_v1'
    get :'verses/code_v2', action: 'verses_text', script: 'code_v2'
    # TODO: Naveed. add Qaloon and other Qira'at
  end

  # verses routes, by juz, chapter, page
  namespace :verses do
    get 'by_page/:page_number', action: 'by_page'
    get 'by_juz/:juz_number', action: 'by_juz'
    get 'by_chapter/:chapter_number', action: 'by_chapter'
    get 'by_rub/:rub_number', action: 'by_rub'
    get 'by_hizb/:hizb_number', action: 'by_hizb'
    get 'by_key/:verse_key', action: 'by_key'
    get :filter

    get 'random', action: 'random'
  end

  # translations routes, by juz, chapter, page
  scope 'translations/:resource_id', controller: 'translations' do
    get 'by_chapter/:chapter_number', action: 'by_chapter'
    get 'by_page/:page_number', action: 'by_page'
    get 'by_juz/:juz_number', action: 'by_juz'
    get 'by_rub/:rub_number', action: 'by_rub'
    get 'by_hizb/:hizb_number', action: 'by_hizb'
    get 'by_ayah/:ayah_key', action: 'by_ayah'
  end

  # tafsir routes, by juz, chapter, page
  scope 'tafsirs/:resource_id', controller: 'tafsirs' do
    get 'by_chapter/:chapter_number', action: 'by_chapter'
    get 'by_page/:page_number', action: 'by_page'
    get 'by_juz/:juz_number', action: 'by_juz'
    get 'by_rub/:rub_number', action: 'by_rub'
    get 'by_hizb/:hizb_number', action: 'by_hizb'
    get 'by_ayah/:ayah_key', action: 'by_ayah'
  end

  # tafsir routes, by juz, chapter, page
  scope 'recitations/:recitation_id', controller: 'recitations' do
    get 'by_chapter/:chapter_number', action: 'by_chapter'
    get 'by_page/:page_number', action: 'by_page'
    get 'by_juz/:juz_number', action: 'by_juz'
    get 'by_rub/:rub_number', action: 'by_rub'
    get 'by_hizb/:hizb_number', action: 'by_hizb'
    get 'by_ayah/:ayah_key', action: 'by_ayah'
  end

  get 'ping', to: 'ping#ping'
  get '/', to: 'ping#ping'
end
