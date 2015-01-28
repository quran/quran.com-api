namespace :db do
  task import: :environment do
    if ActiveRecord::Base.connection.tables.length > 28 && Quran::Surah.all.count == 114
        puts "Database says: You are good to go!"
        next
    else
      sh "rake db:setup_structure"
      sh "rake db:reset; true"
      sh "rake db:migrate; true"
      sh "rake db:seed; true"
    end
  end
end