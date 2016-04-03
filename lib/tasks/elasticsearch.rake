namespace :elasticsearch do
  @models = [
    'Content::Translation',
    'Content::Transliteration',
    'Content::TafsirAyah',
    'Quran::Text',
    'Quran::TextFont'
  ]

  desc 'deletes all elasticsearch indices'
  task delete_indices: :environment do
    ActiveRecord::Base.logger = Logger.new(STDOUT)

    @models.each do |model|
      model = Kernel.const_get(model)
      model.delete_index
    end
  end

  desc 'setup all elasticsearch indices'
  task setup_indices: :environment do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    Parallel.each(@models, in_processes: 4, progress: 'Importing models') do |model|
      model = Kernel.const_get(model)
      model.setup_index
    end
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
