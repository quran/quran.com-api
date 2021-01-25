# frozen_string_literal: true

module Types
  class TokenType < Types::BaseObject
    field :id, ID, null: false
    field :text_madani, String, null: true
    field :text_clean, String, null: true
    field :text_indopak, String, null: true
  end
end
