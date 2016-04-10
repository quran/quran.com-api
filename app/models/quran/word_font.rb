# == Schema Information
#
# Table name: quran.word_font
#
#  resource_id  :integer          not null, primary key
#  ayah_key     :text             not null, primary key
#  position     :integer          not null, primary key
#  word_id      :integer
#  page_num     :integer          not null
#  line_num     :integer          not null
#  code_dec     :integer          not null
#  code_hex     :text             not null
#  char_type_id :integer          not null
#

class Quran::WordFont < ActiveRecord::Base
  extend Quran

  self.table_name = 'word_font'
  self.primary_keys = :resource_id, :ayah_key, :position

  belongs_to :ayah, class_name: 'Quran::Ayah'
  belongs_to :char_type, class_name: 'Quran::CharType'
  belongs_to :resource, class_name: 'Content::Resource'
  belongs_to :word, class_name: 'Quran::Word'

  def class_name
    "p#{page_num}"
  end

  def code
    "&#x#{code_hex}"
  end
end
