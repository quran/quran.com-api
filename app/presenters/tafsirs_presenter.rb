# frozen_string_literal: true

class TafsirsPresenter < VersesPresenter
  attr_reader :finder
  TAFSIR_FIELDS = [
      'chapter_id',
      'verse_number',
      'verse_key',
      'juz_number',
      'hizb_number',
      'rub_el_hizb_number',
      'page_number',
      'ruku_number',
      'manzil_number',
      'resource_name',
      'language_name',
      'language_id',
      'id'
  ]

  def initialize(params)
    super(params, '_')

    @finder = V4::TafsirFinder.new(params)
  end

  def resource_slug
    resource.slug
  end

  def resource_translated_name
    language = Language.find_by(iso_code: fetch_locale)
    names = TranslatedName.where(resource_id: resource_id, resource_type: 'ResourceContent')
    en_name = names.where(language_id: Language.default.id)

    if language
      names.where(language_id: language).or(en_name).order('language_priority DESC').first
    else
      en_name.first
    end
  end

  def tafsir_fields
    strong_memoize :tafsir_fields do
      fetch_fields.select do |field|
        TAFSIR_FIELDS.include?(field)
      end
    end
  end

  def find_tafsirs(filter)
    finder.load_tafsirs(filter, resource_id)
  end

  def load_verses(from, to)
    verse_finder = Qdc::VerseFinder.new(from: from, to: to)

    verse_finder.load_verses('by_range',
                             fetch_locale,
                             mushaf_type: get_mushaf_id,
                             words: render_words?)
  end

  protected

  def resource_id
    resource.id
  end

  def resource
    strong_memoize :approved_tafsir do
      if params[:resource_id]
        id_or_slug = params[:resource_id].to_s

        approved_Tafsirs = ResourceContent
                             .approved
                             .tafsirs

        approved_tafsir = approved_Tafsirs
                            .where(id: id_or_slug)
                            .or(approved_Tafsirs.where(slug: id_or_slug))
                            .first

        raise_404("Tafsir not found") unless  approved_tafsir

        params[:resource_id] = approved_tafsir.id
        approved_tafsir
      else
        raise_404("Tafsir not found")
      end
    end
  end

  def fetch_fields
    if (fields = params[:fields]).presence
      fields.split(',')
    else
      []
    end
  end
end
