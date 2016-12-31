# == Schema Information
#
# Table name: word_transliteration
#
#  transliteration_id :integer          not null, primary key
#  word_id            :integer
#  language_code      :string
#  value              :string
#

class Quran::WordTransliteration < ActiveRecord::Base
  self.table_name = 'word_transliteration'

  belongs_to :word, class_name: 'Quran::Word'
  belongs_to :language, class_name: 'Locale::Language'


  def self.import
    rows = CSV.read('./Transliteration.csv')
    # rows.each do |r|
      surah = rows.first[0]
      ayah = rows.first[1]
      ayah_key = "#{surah}:#{ayah}"
      position = rows.first[2]
      puts ayah_key

      word = Quran::Word.find_by(ayah_key: ayah_key, position: position)

      create(transliteration_id: word.id, word_id: word.id, language_code: 'en', value: r[3])
    # end
  end
end
