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
    attr :pages
    attr :verses_count
    attr :chapter_number

    has_many_array :verses
    has_many_array :chapter_infos
  end
end
