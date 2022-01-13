# frozen_string_literal: true

class TranslationsPresenter < BasePresenter
  attr_reader :finder

  TRANSLATION_FIELDS = [
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
    super(params)

    @finder = V4::TranslationFinder.new(params)
  end

  delegate :total_records, to: :finder

  def translation_fields
    strong_memoize :valid_fields do
      fetch_fields.select do |field|
        TRANSLATION_FIELDS.include?(field)
      end
    end
  end

  def translations(filter)
    finder.load_translations(filter, resource_id)
  end

  protected
  def resource_id
    strong_memoize :approved_translation do
      if params[:resource_id]
        translations = params[:resource_id].to_s

        approved_translations = ResourceContent
                                    .approved
                                    .translations
                                    .one_verse

        params[:resource_id] = approved_translations
                                    .where(id: translations)
                                    .or(approved_translations.where(slug: translations))
                                    .pick(:id)
        params[:resource_id]
      else
        []
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
