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
             :code_v3

  attribute :char_type_name, key: :char_type

  attribute :audio do
    {url: object.audio_url}
  end

  has_one :translation, serializer: V3::TranslationSerializer do
    object.public_send("#{scope[:language] || 'en'}_translations").first || object.en_translations.first
  end

  has_one :transliteration, serializer: V3::TransliterationSerializer do
    # We've transliterations in English
    object.en_transliterations.first
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
