# frozen_string_literal: true

Types::ChapterInfoType = GraphQL::ObjectType.define do
  name 'ChapterInfo'

  backed_by_model :chapter_info do
    attr :id
    attr :chapter_id
    attr :text
    attr :source
    attr :short_text
    attr :language_id
    attr :resource_content_id
    attr :language_name

    has_one :chapter
  end
end
