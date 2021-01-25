# frozen_string_literal: true

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
module Api
  class V3::WordSerializer < V3::ApplicationSerializer
    attributes :id,
               :position,
               :text_indopak,
               :verse_key,
               :class_name,
               :line_number,
               :page_number,
               :code

    attribute :text_madani do
      object.text_uthmani
    end

    attribute :text_simple do
      object.text_imlaei_simple
    end

    attribute :char_type_name, key: :char_type

    attribute :transliteration do
      { text: object.en_transliteration, language_name: 'english' }
    end

    attribute :audio do
      { url: object.audio_url }
    end

    has_one :translation, serializer: V3::WordTranslationSerializer do
      object.word_translation
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
end
