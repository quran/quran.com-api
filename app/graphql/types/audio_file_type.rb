# frozen_string_literal: true

module Types
  class AudioFileType < Types::BaseObject
    field :id, ID, null: false
    field :verse_id, Integer, null: true
    field :url, String, null: true
    field :duration, Integer, null: true
    field :segments, String, null: true
    field :recitation_id, Integer, null: true
  end
end
