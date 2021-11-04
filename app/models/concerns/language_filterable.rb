# frozen_string_literal: true

# vim: ts=4 sw=4 expandtab
module LanguageFilterable
  extend ActiveSupport::Concern

  included do
    belongs_to :language

    def self.filter_by_language_or_default(language = 'en')
      language = Language.find_with_id_or_iso_code(language)

      if language.nil? || language.default?
        find_by(language_id: Language.default.id)
      else
        find_by(language_id: language.id)
      end
    end
  end
end
