# frozen_string_literal: true

module Slugable
  extend ActiveSupport::Concern

  included do
    has_many :slugs
    # For eager loading
    has_one :default_slug, class_name: 'Slug'

    def self.find_using_slug(slug, items = nil)
      slugged = Slug.where(slug: CGI::unescape(slug)).first
      (items || Chapter).where(id: [slugged&.chapter_id, slug]).first
    end
  end
end
