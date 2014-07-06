class Content::Resource < ActiveRecord::Base
    extend Content

    self.table_name = 'resource'
    self.primary_key = 'resource_id'

    belongs_to :author, class_name: 'Content::Author'
    belongs_to :source, class_name: 'Content::Source'
    belongs_to :language, class_name: 'I18n::Language', foreign_key: 'language_code'

    # maybe make the block below a polymorphic class, accessible via 'content' or something
    # dunno wth polymorphic relationships really are, so maybe not -- fancy crap not worth a brain cell
    has_many :_image, class_name: 'Quran::Image', foreign_key: 'resource_id'
    has_many :_text, class_name: 'Quran::Text', foreign_key: 'resource_id'
    has_many :_word_font, class_name: 'Quran::WordFont', foreign_key: 'resource_id'
    has_many :_tafsir, class_name: 'Content::Tafsir', foreign_key: 'resource_id'
    has_many :_translation, class_name: 'Content::Translation', foreign_key: 'resource_id'
    has_many :_transliteration, class_name: 'Content::Transliteration', foreign_key: 'resource_id'
    has_one  :_resource_api_version, class_name: 'Content::ResourceAPIVersion', foreign_key: 'resource_id'
end
