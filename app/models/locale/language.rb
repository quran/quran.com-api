# == Schema Information
#
# Table name: language
#
#  language_code       :text             not null, primary key
#  unicode             :text
#  english             :text             not null
#  direction           :text             default("ltr"), not null
#  priority            :integer          default(999), not null
#  beta                :boolean          default(TRUE), not null
#  es_analyzer_default :string
#

class Locale::Language < ActiveRecord::Base
    extend Locale

    self.table_name = 'language'
    self.primary_key = 'language_code'

    has_many :content_resources, class_name: 'Content::Resource', foreign_key: 'language_code'
    has_many :word_for_word_translations, class_name: 'Quran::WordTranslation', foreign_key: 'language_code'
end
