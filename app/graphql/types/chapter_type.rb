module Types
  class ChapterType < Types::BaseObject
    field :id, ID, null: false
    field :chapter_number, Integer, null: false, description: 'Surah number'
    field :bismillah_pre, Boolean, null: false, description: 'Boolean attribute indicating if this surah should show bismillah'
    field :revelation_order, Integer, null: false
    field :revelation_place, String, null: false
    field :name_complex, String, null: false
    field :name_arabic, String, null: false
    field :name_simple, String, null: false
    field :pages, [Int], null: false
    field :verses_count, Integer, null: false

    field :translated_name, Types::TranslatedNameType, "Translated chapter names", null: true do
      argument :language, String, required: true, default_value: 'en'
    end

    def translated_name(language:)
      object.translated_name
    end

    field :verses,
          [Types::VerseType],
          "verses for this chapter, max 50 results per call",
          null: true,
          extras: [:lookahead],
          max_page_size: 50 do
      argument :from, Integer, "starting ayah number", required: false
      argument :to, Integer, "last ayah number", required: false
      argument :page, Integer, "page number for paginating within from-to ayah range", required: false, default_value: 1
      argument :per_page, Integer, "number of ayahs per call", required: false, default_value: 10
    end

    def verses(lookahead:, from:, to:, page: 1, per_page: 10, language: 'en')
      finder = V4::VerseFinder.new({
                                       chapter_number: object.id,
                                       from: from,
                                       to: to,
                                       page: page,
                                       per_page: per_page
                                   })


      finder.load_verses(
          'by_chapter',
          language,
          words: lookahead.selects?(:words),
          tafsirs: fetch_tafsirs(lookahead),
          translations: fetch_translations(lookahead),
          audio: fetch_audio(lookahead)
      )
    end

    def fetch_tafsirs(lookahead)
      if args = lookahead.selection(:tafsirs).arguments
        args[:tafsir_ids]
      end
    end

    def fetch_translations(lookahead)
      if args = lookahead.selection(:translations).arguments
        args[:translation_ids]
      end
    end

    def fetch_audio(lookahead)
      if args = lookahead.selection(:audio).arguments
        args[:recitation]
      end
    end
  end
end
