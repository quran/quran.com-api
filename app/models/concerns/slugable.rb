# frozen_string_literal: true

module Slugable
  extend ActiveSupport::Concern

  included do
    has_many :slugs
    # For eager loading
    has_one :default_slug, class_name: 'Slug'

    def self.find_using_slug(slug, items = nil)
      with_slugs = items || joins(:slugs)

      with_slugs
        .where('slugs.slug': slug)
        .or(with_slugs.where(id: slug))
        .first
    end
  end
end
