namespace :one_time do
  task fix_tafsir: :environment do
    Tafsir.includes(:verse).each do |tafsir|
      tafsir.update_attribute :verse_key, tafsir.verse.verse_key
    end
  end
end
