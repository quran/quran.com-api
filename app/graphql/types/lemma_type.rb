# frozen_string_literal: true

module Types
  class LemmaType < Types::BaseObject
    field :id, ID, null: false
    field :text_madani, String, null: true
    field :text_clean, String, null: true
  end
end
