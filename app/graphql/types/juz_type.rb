module Types
  class JuzType < Types::BaseObject
    field :id, ID, null: false
    field :juz_number, Integer, null: true
    field :verse_mapping, GraphQL::Types::JSON, null: true
    field :verses,
          [Types::VerseType],
          "verses for this juz, max 50 results per call",
          null: true,
          extras: [:lookahead],
          max_page_size: 50 do
      argument :page, Integer, "page number for paginating within from-to ayah range", required: false, default_value: 1
      argument :per_page, Integer, "number of ayahs per call", required: false, default_value: 10
    end

    def verses(lookahead:,  page: 1, per_page: 10, language: 'en')
      finder = V4::VerseFinder.new({
                                       juz_number: object.id,
                                       page: page,
                                       per_page: per_page
                                   })

      finder.load_verses(
          'by_juz',
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
