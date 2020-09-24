module Slugable
  extend ActiveSupport::Concern

  included do
    def self.find_using_slug(slug)
      joins(:slugs).where('slugs.slug': slug).first || find_by(id: slug)
    end
  end
end
