namespace :elasticsearch do

  desc 'deletes all elasticsearch indices'
  task delete_indices: :environment do
    Verse.__elasticsearch__.delete_index!
  end

  desc 'reindex elasticsearch'
  task re_index: :environment do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    Verse.__elasticsearch__.import force: true
  end

  desc 'setup elasticsearch files'
  task setup_files: :environment do
    analysis_dir = '/usr/local/etc/elasticsearch/analysis'

    Dir.mkdir(analysis_dir) unless File.exist?(analysis_dir)

    Dir['config/elasticsearch/analysis/*'].each do |curr_path|
      File.open(
        "/usr/local/etc/elasticsearch/analysis/#{Pathname.new(curr_path).basename}",
        'w'
      ) do |f|
        f.write(File.open(curr_path).read)
      end if File.file?(curr_path)
    end
  end
end
