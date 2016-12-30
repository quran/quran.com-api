# == Schema Information
#
# Table name: verses
#
#  id           :integer          not null, primary key
#  chapter_id   :integer
#  verse_number :integer
#  verse_key    :string
#  text_madani  :text
#  text_indopak :text
#  text_simple  :text
#  juz_num      :integer
#  hizb_num     :integer
#  rub_num      :integer
#  sajdah       :integer
#  page_number  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class VerseSerializer < ActiveModel::Serializer
  attributes :id, :verse_number, :verse_key, :text_madani, :text_indopak, :text_simple, :juz_num, :hizb_num, :rub_num, :sajdah, :page_number
  has_one :chapter
end
