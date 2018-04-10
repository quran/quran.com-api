# frozen_string_literal: true

Types::RootType = GraphQL::ObjectType.define do
  name 'Root'

  backed_by_model :root do
    attr :id
    attr :value
  end
end
