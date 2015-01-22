namespace :db do
  task import: :environment do
    if ActiveRecord::Base.connected?
      unless ActiveRecord::Base.connection.tables.length > 20 && ActiveRecord::Base.connection.table_exists?('surah')
        unless Quran::Surah.all.count == 114
          sh "rake db:setup_structure"
          sh "rake db:reset; true"
          sh "rake db:migrate; true"
          sh "rake db:seed; true"
        end
      end
      next
    else
      sh "rake db:setup_structure"
      sh "rake db:reset; true"
      sh "rake db:migrate; true"
      sh "rake db:seed; true"

    end
  end
end