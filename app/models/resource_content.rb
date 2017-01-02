# == Schema Information
#
# Table name: resource_contents
#
#  id               :integer          not null, primary key
#  approved         :boolean
#  author_id        :integer
#  data_source_id   :integer
#  author_name      :string
#  resource_type    :string
#  sub_type         :string
#  name             :string
#  description      :text
#  cardinality_type :string
#  language_id      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class ResourceContent < ApplicationRecord
  module CardinalityType
    OneVerse = '1_ayah'
    OneWord = '1_word'
    NVerse = 'n_ayah'
    OneChapter = '1_chapter'
  end

  module ResourceType
    Audio = 'audio'
    Content = 'content'
    Quran = 'quran'
    Media = 'media'
  end

  module SubType
    Translation = 'translation'
    Tafsir = 'tafsir'
    Transliteration = 'transliteration'
    Font = 'font'
    Image = 'image'
    Info = 'info'
  end

  belongs_to :author
  belongs_to :language
  belongs_to :data_source
end
