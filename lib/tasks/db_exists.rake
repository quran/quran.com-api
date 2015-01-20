namespace :db do
  task exists: :environment do
    puts Quran::Surah.count == 114
  end
end