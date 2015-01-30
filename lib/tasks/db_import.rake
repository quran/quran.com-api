namespace :db do
  task import: :environment do
    if ActiveRecord::Base.connection.tables.length > 28 && Quran::Surah.all.count == 114
        puts "Database says: You are good to go!"
        next
    else
      sh "rake db:setup_structure"
      sh "rake db:create; true"
      sh "rake db:setup; true"
      sh "rake db:migrate; true"
    end
  end
end