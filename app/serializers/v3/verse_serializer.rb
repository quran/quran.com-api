# == Schema Information
#
# Table name: verses
#
#  id            :integer          not null, primary key
#  chapter_id    :integer
#  verse_number  :integer
#  verse_index   :integer
#  verse_key     :string
#  text_madani   :text
#  text_indopak  :text
#  text_simple   :text
#  juz_number    :integer
#  hizb_number   :integer
#  rub_number    :integer
#  sajdah        :string
#  sajdah_number :integer
#  page_number   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class V3::VerseSerializer < V3::ApplicationSerializer
  attributes :id, :verse_number, :chapter_id, :verse_key, :text_madani, :text_indopak, :text_simple, :juz_number, :hizb_number, :rub_number, :sajdah, :sajdah_number, :page_number
  has_many :words
end
