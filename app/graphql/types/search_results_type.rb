# frozen_string_literal: true

module Types
  class SearchResultsType < Types::BaseObject
    field :query, String, null: false
    field :total_count, Int, null: false
    field :took, Int, null: false
    field :current_page, Int, null: false
    field :total_pages, Int, null: false
    field :per_page, Int, null: false
    field :results, [Types::VerseType], null: false
  end
end
