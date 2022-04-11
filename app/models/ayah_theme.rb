# == Schema Information
# Schema version: 20220411000741
#
# Table name: ayah_themes
#
#  id                :bigint           not null, primary key
#  theme             :string
#  verse_id_from     :integer
#  verse_id_to       :integer
#  verse_key_from    :string
#  verse_key_to      :string
#  verse_number_from :integer
#  verse_number_to   :integer
#  verses_count      :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  chapter_id        :integer
#
# Indexes
#
#  index_ayah_themes_on_chapter_id         (chapter_id)
#  index_ayah_themes_on_verse_id_from      (verse_id_from)
#  index_ayah_themes_on_verse_id_to        (verse_id_to)
#  index_ayah_themes_on_verse_number_from  (verse_number_from)
#  index_ayah_themes_on_verse_number_to    (verse_number_to)
#
class AyahTheme < ApplicationRecord
end
