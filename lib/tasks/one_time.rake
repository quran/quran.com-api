namespace :one_time do
  task replace_wbw_translation: :environment do
    changed = []
    
    data = CSV.open("final_wbw_translation.csv").read
    
    data[1..data.size].each do |row|
      word = Word.find(row[0])
      if word.en_translations.first.text != row[2]
        changed[word.id] = {current: word.en_translations.first.text, new: row[2]}
      end
      
      word.en_translations.first.update_column :text, row[2]
    end
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
