# frozen_string_literal: true

Types::RecitationType = GraphQL::ObjectType.define do
  name 'Recitation'

  backed_by_model :recitation do
    attr :id
    attr :reciter_id
    attr :resource_content_id
    attr :recitation_style_id
    attr :reciter_name
    attr :style
  end
end
