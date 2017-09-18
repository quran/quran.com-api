Types::ChapterType = GraphQL::ObjectType.define do
  name 'Chapter'

  backed_by_model :chapter do
    attr :id
    attr :bismillah_pre
    attr :revelation_order
    attr :revelation_place
    attr :name_complex
    attr :name_arabic
    attr :name_simple
    attr :verses_count
    attr :chapter_number

    has_many_connection :verses
    has_many_array :chapter_infos

    field :pages, types[types.Int] do
      resolve ->(chapter, _args, _ctx) { chapter.pages }
    end

    field :translatedName, Types::TranslatedNameType do
      argument :language, types.String, default_value: 'en'
      resolve ->(chapter, args, _ctx) do
        chapter.public_send("#{args[:language]}_translated_names".to_sym).first
      end
    end
  end
end
