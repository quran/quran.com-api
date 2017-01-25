# == Schema Information
#
# Table name: words
#
#  id           :integer          not null, primary key
#  verse_id     :integer
#  position     :integer
#  text_madani  :text
#  text_indopak :text
#  text_simple  :text
#  verse_key    :string
#  page_number  :integer
#  line_number  :integer
#  code_dec     :integer
#  code_hex     :string
#  char_type_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class V3::WordSerializer < V3::ApplicationSerializer
  attributes :position, :text_madani, :text_indopak, :text_simple, :verse_key, :class_name, :line_number, :code, :char_type

  #ON HOLD: Actually we don't have word audio for now
  #has_one  :audio, serializer: V3::AudioFileSerializer

  has_one :translation do
    object.translations.filter_by_language_or_default scope[:translations]
  end

  has_one :transliteration do
    object.transliterations.filter_by_language_or_default scope[:translations]
  end

  def char_type
    object.char_type.name
  end

  def class_name
    "p#{object.page_number}"
  end

  def code
    "&#x#{object.code_hex};"
  end
end
