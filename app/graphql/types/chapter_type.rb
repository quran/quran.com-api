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

    field :translated_name, Types::TranslatedNameType, null: true do
      argument :language, String, required: true, default_value: 'en'
    end

    def translated_name(language:)
      object.translated_name
    end
  end
end
