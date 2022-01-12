namespace :qdc do
  # available resources
  namespace :resources do
    get :translations
    get 'translations/:translation_id/info', action: 'translation_info'
    get 'translations/filter', action: 'filter'
    get :tafsirs
    get 'tafsirs/:tafsir_id/info', action: 'tafsir_info'
    # TODO: move to audio
    get :recitations
    get 'recitations/:recitation_id/info', action: 'recitation_info'
    # TODO: move to audio
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
  get 'pages/:id', to: 'pages#show'

  # verses routes, by juz, chapter, page
  namespace :verses do
    get 'by_page/:page_number', action: 'by_page'
    get 'by_juz/:juz_number', action: 'by_juz'
    get 'by_chapter/:chapter_number', action: 'by_chapter'
    get 'by_rub/:rub_el_hizb_number', action: 'by_rub'
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
    # Surah audio
    get 'reciters', to: 'chapter_recitations#reciters'
    get 'reciters/:reciter_id', to: 'chapter_recitations#reciter_audio_files'

    # Get timestamp for ayah
    get 'reciters/:reciter_id/timestamp', to: 'segments#timestamp'

    # Segments and percentiles
    get 'reciters/:reciter_id/lookup', to: 'segments#lookup_ayah'
    get 'reciters/:reciter_id/percentiles', to: 'percentiles#cumulative_percentile'
    get 'reciters/:reciter_id/ayah_percentiles', to: 'percentiles#ayah_duration_percentile'
  end

  # routes for fetching all records of one resource.
  # i.e /v4/quran/translations/131 will send complete Clear Quran translation
  namespace :quran do
    get 'translations/:translation_id', action: 'translation'
    get 'tafsirs/:tafsir_id', action: 'tafsir'
    get 'verses/:script', action: 'verses_text'
  end

  # translations routes, by juz, chapter, page
  scope 'translations/:resource_id', controller: 'translations' do
    get 'by_chapter/:chapter_number', action: 'by_chapter'
    get 'by_page/:page_number', action: 'by_page'
    get 'by_juz/:juz_number', action: 'by_juz'
    get 'by_rub/:rub_el_hizb_number', action: 'by_rub'
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
    get 'by_rub/:rub_el_hizb_number', action: 'by_rub'
    get 'by_hizb/:hizb_number', action: 'by_hizb'
    get 'by_manzil/:manzil_number', action: 'by_manzil'
    get 'by_ruku/:ruku_number', action: 'by_ruku'
    get 'by_ayah/:ayah_key', action: 'by_ayah'
  end

  scope 'recitations/:recitation_id', controller: 'recitations' do
    get 'by_chapter/:chapter_number', action: 'by_chapter'
    get 'by_page/:page_number', action: 'by_page'
    get 'by_juz/:juz_number', action: 'by_juz'
    get 'by_rub/:rub_el_hizb_number', action: 'by_rub'
    get 'by_hizb/:hizb_number', action: 'by_hizb'
    get 'by_manzil/:manzil_number', action: 'by_manzil'
    get 'by_ruku/:ruku_number', action: 'by_ruku'
    get 'by_ayah/:ayah_key', action: 'by_ayah'
  end

  get 'ping', to: 'ping#ping'
  get '/', to: 'ping#ping'
end
