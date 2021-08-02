# frozen_string_literal: true

module NameTranslateable
  extend ActiveSupport::Concern

  included do
    has_many :translated_names, as: :resource

    # For eager loading
    has_one :translated_name, as: :resource
  end

  def localised_name
    translated_name&.name
  end
end
