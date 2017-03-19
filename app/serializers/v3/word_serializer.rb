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
  attributes :id,
             :position,
             :text_madani,
             :text_indopak,
             :text_simple,
             :verse_key,
             :class_name,
             :line_number,
             :page_number,
             :code,
             :code_v3,
             :char_type

  has_one :audio, serializer: V3::AudioFileSerializer

  has_one :translation do
    # object.translations.filter_by_language_or_default scope[:language]
    # object.translations.public_send("#{scope[:language] || 'en'}_language")
    object.public_send("#{scope[:language] || 'en'}_translations").first
    # object.translations
  end

  has_one :transliteration do
    # object.transliterations.filter_by_language_or_default scope[:language]
    # object.transliterations.public_send("#{scope[:language] || 'en'}_language")
    object.public_send("#{scope[:language] || 'en'}_transliterations").first
    # object.transliterations
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

  def code_v3
    "&#x#{object.code_hex_v3};"
  end
end
