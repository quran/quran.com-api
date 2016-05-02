# == Schema Information
#
# Table name: quran.word
#
#  word_id  :integer          not null, primary key
#  ayah_key :text             not null
#  position :integer          not null
#  token_id :integer          not null
#

class Quran::Word < ActiveRecord::Base
  extend Quran

  self.table_name = 'word'
  self.primary_key = 'word_id'

  belongs_to :ayah, class_name: 'Quran::Ayah'
  belongs_to :token, class_name: 'Quran::Token'

  has_one :corpus, class_name: 'Quran::WordCorpus', foreign_key: :word_id
  has_one :translation, class_name: 'Quran::WordTranslation', foreign_key: :word_id
  has_one :transliteration, class_name: 'Quran::WordTransliteration', foreign_key: :word_id

  has_many :glyphs, class_name: 'Quran::WordFont', foreign_key: :word_id

  has_many :_word_lemma, class_name: 'Quran::WordLemma', foreign_key: :word_id
  has_many :_word_root, class_name: 'Quran::WordRoot', foreign_key: :word_id
  has_many :_word_stem, class_name: 'Quran::WordStem', foreign_key: :word_id

  has_many :stems,  class_name: 'Quran::Stem',  through: :_word_stem
  has_many :lemmas, class_name: 'Quran::Lemma', through: :_word_lemma
  has_many :roots,  class_name: 'Quran::Root',  through: :_word_root

  def as_json(options = {})
    super().merge(
      translation: translation.value,
      transliteration: transliteration.value,
      corpus: {
        description: corpus.description,
        image_src: corpus.image_src,
        segment: corpus.segment
      }
    )
  end
end
