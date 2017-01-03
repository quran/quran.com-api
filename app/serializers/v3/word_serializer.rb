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
  attributes :position, :text_madani, :text_indopak, :text_simple, :verse_key, :class_name, :line_number, :code_dec, :code, :char_type

  def char_type
    object.char_type.name
  end

  def class_name
    "p#{object.page_number}"
  end

  def code
    "&#x#{object.code_hex}"
  end

  def translation
    word && word.translation
  end

  def transliteration
    word && word.transliteration
  end

end
