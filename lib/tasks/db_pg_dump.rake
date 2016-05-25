namespace :db do
  desc 'Dump the database'
  task pg_dump: :environment do
    previous_version = Dir['db/dumps/**'].map{ |dir| dir.split('/').last }.sort_by{|version| version.to_i}.last.to_i + 1
    sh "mkdir db/dumps/#{previous_version}"
    sh "mv db/quran_dev.psql.bz2 db/dumps/#{previous_version}"
    sh "touch db/dumps/#{previous_version}/CHANGES.md"
    sh "pg_dump quran_dev -U quran_dev > db/quran_dev.psql"
    sh "bzip2 db/quran_dev.psql"
  end

  task load_pg_dump: :environment do
    sh "bunzip2 db/quran_dev.psql.bz2"
    sh "psql -U quran_dev quran_dev < db/quran_dev.psql"
    sh "bzip2 db/quran_dev.psql"
  end
end
