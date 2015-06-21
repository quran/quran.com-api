namespace :db do
  task setup_structure: :environment do
    FileUtils.copy_file('db/structure.sql.init', 'db/structure.sql')
    sh "rails db < db/structure.sql"
  end
end
