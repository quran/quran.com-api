# frozen_string_literal: true

namespace :one_time do
  task fix_urdu_wbw: :environment do
    require 'csv'

    # Update missing wbw urdu from production db
    CSV.foreach('word_ur.csv') do |w|
      if word = Word.find_by(id: w[0])
        word.ur_translations.update_all text: w[1] if w[1].present?
        puts word.id
      end
    end

    class ArabicTransliteration < ApplicationRecord
      belongs_to :word
    end

    urdu = Language.find_by(id_or_iso_code: 'ur')

    # Update missing urdu wbw from arabic transliteration
    ArabicTransliteration.includes(:word).each do |at|
      if word = at.word
        if at.ur_translation.present?
          word.ur_translations.update_all text: at.ur_translation.strip
          WordTranslation.where(word_id: at.word_id, language_id: urdu.id, language_name: 'urdu', resource_content_id: 104).first_or_create.update_column(:text, at.ur_translation.strip)
        end
      end
    end

    # Still missing urdu wbw
    puts "missing words #{Translation.where(resource_type: 'Word', text: '').count}"
    25714
    # Create word translations
    Translation.where(resource_type: 'Word').find_each do |t|
      if t.text.present?
        WordTranslation.where(word_id: t.resource_id, language_id: t.language_id, language_name: t.language_name, resource_content_id: t.resource_content_id).first_or_create.update_column(:text, t.text)
      end
    end
  end

  task fix_audio_url: :environment do
    Word.includes(:audio).find_each do |w|
      w.audio&.update_column :url, w.audio_url
    end

    Word.update_all("audio_url = REPLACE(audio_url, '//verses.quran.com/wbw/', 'verses/wbw/')")
    AudioFile.update_all("url = REPLACE(url, '//verses.quran.com', 'verses')")
    AudioFile.update_all("url = REPLACE(url, 'https:', '')")
  end

  task fix_tafsir: :environment do
    Tafsir.includes(:verse).each do |tafsir|
      tafsir.update_attribute :verse_key, tafsir.verse.verse_key
    end
  end

  task create_juzs: :environment do
    1.upto(30).each do |juz_number|
      juz = Juz.where(juz_number: juz_number).first_or_create

      map = {}
      juz.chapters.each do |chapter|
        juz_verses = chapter.verses.where(juz_number: juz_number).order('verse_number asc')
        map[chapter.chapter_number] = "#{juz_verses.first.verse_number}-#{juz_verses.last.verse_number}"
      end

      juz.verse_mapping = map
      juz.save
    end
  end
end
