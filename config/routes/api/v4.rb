namespace :v4 do
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

    get 'random', action: 'random'
  end

  # TODO: move this to qa(Quranic audio) namespace
  namespace :audio do
    # https://quranicaudio.com/api/surahs
    # https://quranicaudio.com/api/surahs/1

    get :qaris, to: 'recitations#index'
    get 'qaris/:id', to: 'recitations#show'
    get 'qaris/related/:id', to: 'recitations#related'
    get 'qaris/:id/audio_files/:ext', to: 'recitations#audio_files'
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

  # Footnote
  get 'foot_notes/:id', to: 'foot_notes#show'

  # available resources
  namespace :resources do
    get :translations
    get 'translations/:translation_id/info', action: 'translation_info'
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
    get 'tafsirs/:tafsir_id', action: 'tafsir'
    get 'recitations/:recitation_id', action: 'recitation'
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

  # tafsir routes, by juz, chapter, page
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

  # Surah audio
  scope 'chapter_recitations/:reciter_id', controller: 'chapter_recitations' do
    get '/', action: 'index'
    get '/:chapter_number', action: 'by_chapter'
  end

  get 'ping', to: 'ping#ping'
  get '/', to: 'ping#ping'
end
