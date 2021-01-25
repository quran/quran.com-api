# frozen_string_literal: true

module Slugable
  extend ActiveSupport::Concern

  included do
    has_many :slugs

    def self.find_using_slug(slug)
      joins(:slugs).where('slugs.slug': slug).first || find_by(id: slug)
    end
  end
end
