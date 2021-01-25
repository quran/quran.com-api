# frozen_string_literal: true

module Types
  class WordTranslationType < Types::BaseObject
    field :id, ID, null: false
    field :language_id, Integer, null: true
    field :language_name, String, null: true
    field :text, String, null: true
    field :word_id, Integer, null: true
  end
end
