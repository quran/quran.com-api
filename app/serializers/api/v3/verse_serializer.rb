# frozen_string_literal: true

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
module Api
  class V3::VerseSerializer < V3::ApplicationSerializer


    has_one :audio, if: :render_audio?, serializer: V3::AudioFileSerializer

    has_many :translations, if: :render_translations?




    def audio
      object.audio_file
    end
  end
end
