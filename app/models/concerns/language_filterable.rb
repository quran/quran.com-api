# frozen_string_literal: true

# vim: ts=4 sw=4 expandtab
module LanguageFilterable
  extend ActiveSupport::Concern

  included do
    belongs_to :language

    Language.all.each do |language|
      scope "#{language.iso_code}_language", -> { find_by(language: language) }
    end

    def self.filter_by_language_or_default(language = 'en')
      language = Language.find_by_id_or_iso_code(language)

      find_by(language: language) || find_by(language: Language.default)
    end
  end
end
