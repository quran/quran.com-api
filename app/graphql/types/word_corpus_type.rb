# frozen_string_literal: true

module Types
  class WordCorpusType < Types::BaseObject
    field :id, ID, null: false
    field :word_id, Integer, null: true
    field :location, String, null: true
    field :description, String, null: true
    field :image_src, String, null: true
    field :segments, String, null: true
  end
end
