# vim: ts=4 sw=4 expandtab
module LanguageFilterable
  extend ActiveSupport::Concern

  included do
    belongs_to :language
    before_save :update_language_name

    def self.filter_by_language_or_default(language)
      language = Language.find_by_id_or_iso_code(language || 'en')

      self.find_by(language: language) || self.find_by(language: Language.default)
    end
  end

  protected
  def update_language_name
    #TODO: move validation and callback into community app
    self.language_name = language.name
  end
end
