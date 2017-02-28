# == Schema Information
#
# Table name: words
#
#  id           :integer          not null, primary key
#  verse_id     :integer
#  chapter_id   :integer
#  position     :integer
#  text_madani  :text
#  text_indopak :text
#  text_simple  :text
#  verse_key    :string
#  page_number  :integer
#  class_name   :string
#  line_number  :integer
#  code_dec     :integer
#  code_hex     :string
#  code_hex_v3  :string
#  code_dec_v3  :integer
#  char_type_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Word < ApplicationRecord
  belongs_to :verse
  belongs_to :char_type

  has_many :translations, as: :resource
  has_many :transliterations, as: :resource
  has_many :word_topics
  has_many :topics, through: :word_topics
  has_many :word_lemmas
  has_many :lemmas, through: :word_lemmas
  has_many :word_stems
  has_many :stems, through: :word_stems



  has_one  :audio, class_name: 'AudioFile', as: :resource
  has_one :word_corpus

  default_scope {order 'position asc'}
end
