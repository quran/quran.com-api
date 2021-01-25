# frozen_string_literal: true

module Types
  class ChapterInfoType < Types::BaseObject
    field :id, ID, null: true
    field :chapter_id, Integer, null: true
    field :text, String, null: true
    field :source, String, null: true
    field :short_text, String, null: true
    field :language_name, String, null: true
  end
end
