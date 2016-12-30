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

class WordSerializer < ActiveModel::Serializer
  attributes :id, :position, :text_clean, :verse_key, :page_number, :line_number, :code_dec, :code_hex
  has_one :verse
  has_one :char_type
end
