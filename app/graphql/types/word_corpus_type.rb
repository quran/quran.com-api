# frozen_string_literal: true

Types::WordCorpusType = GraphQL::ObjectType.define do
  name 'WordCorpus'

  backed_by_model WordCorpus do
    attr :id
    attr :word_id
    attr :location
    attr :description
    attr :image_src
    attr :segments

    has_one :word
  end
end
