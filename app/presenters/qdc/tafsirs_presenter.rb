# frozen_string_literal: true
module Qdc
  class TafsirsPresenter < VersesPresenter
    attr_reader :finder
    TAFSIR_FIELDS = [
      'chapter_id',
      'verse_number',
      'verse_key',
      'juz_number',
      'hizb_number',
      'rub_number',
      'page_number',
      'resource_name',
      'language_name',
      'language_id',
      'id'
    ]

    def initialize(params)
      super(params, '')

      @finder = V4::TafsirFinder.new(params)
    end

    delegate :total_records, to: :finder

    def tafsir_fields
      strong_memoize :valid_fields do
        fetch_fields.select do |field|
          TAFSIR_FIELDS.include?(field)
        end
      end
    end

    def tafsirs(filter)
      finder.load_tafsirs(filter, resource_id)
    end

    def load_verses(from, to)
      verse_finder = Qdc::VerseFinder.new(from: from, to: to)

      verse_finder.load_verses('range',
                           fetch_locale,
                           mushaf_type: get_mushaf_id,
                           words: render_words?)
    end

    protected

    def resource_id
      strong_memoize :approved_tafsir do
        if params[:resource_id]
          tafsir = params[:resource_id].to_s

          approved_Tafsirs = ResourceContent
                               .approved
                               .tafsirs
                               .one_verse

          params[:resource_id] = approved_Tafsirs
                                   .where(id: tafsir)
                                   .or(approved_Tafsirs.where(slug: tafsir))
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
end