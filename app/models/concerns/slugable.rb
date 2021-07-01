# frozen_string_literal: true

module Slugable
  extend ActiveSupport::Concern

  included do
    has_many :slugs
    # for eager loading
    has_one :default_slug, -> { where(is_default: true ) }, class_name: 'Slug'

    def self.find_using_slug(slug)
      joins(:slugs).where('slugs.slug': slug).first || find_by(id: slug)
    end
  end
end
