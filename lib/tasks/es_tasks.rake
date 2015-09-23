namespace :es_tasks do
  desc "deletes all elasticsearch indices"
  task delete_index: :environment do
    ActiveRecord::Base.logger = Logger.new( STDOUT )
    Searchable.delete_index
  end

  desc "creates all elasticsearch indices"
  task create_index: :environment do
    ActiveRecord::Base.logger = Logger.new( STDOUT )
    Searchable.create_index
  end

  desc "setup all elasticsearch indices"
  task setup_index: :environment do
    analysis_dir = "/usr/local/etc/elasticsearch/analysis"

    Dir.mkdir(analysis_dir) unless File.exists?(analysis_dir)

    Dir["config/elasticsearch/analysis/*"].each do |curr_path|
      File.open("/usr/local/etc/elasticsearch/analysis/#{Pathname.new(curr_path).basename}", 'w') do |f|
        f.write(File.open(curr_path).read)
      end if File.file?(curr_path)
    end

    # ActiveRecord::Base.logger = Logger.new( STDOUT )
    # Rails.logger.level = Logger::INFO
    Searchable.setup_index
  end
end
