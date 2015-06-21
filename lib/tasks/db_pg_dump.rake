namespace :db do
  desc 'Dump the database with pg_dump'
  task pg_dump: :environment do
    sh "pg_dump quran_dev -U quran_dev > db/dumps/quran_dev.#{Time.now.year}-#{Time.now.month}-#{Time.now.day}.psql"
  end
end
