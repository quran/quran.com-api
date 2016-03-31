namespace :elasticsearch do
  @models = [
    'Content::Translation',
    'Content::Transliteration',
    'Content::TafsirAyah',
    'Quran::Text',
    'Quran::TextFont'
  ]

  # I don't remmeber what this is for. I will find out soon.
  def self.create_index
    @models.each do |model|
      model = Kernel.const_get(model)
      model.create_index
    end
  end

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

# For later
# def self.setup_index
#   if Rails.env.production?
#     Elasticsearch::Model.client = Elasticsearch::Client.new host: ENV['ELASTICSEARCH_PORT_9200_TCP_ADDR']
#   end
#
#   return if Elasticsearch::Model.client.client.cluster.health['unassigned_shards'] == 200
#
#   # Let's check to see which is missing and go from there.
#   begin
#     if Elasticsearch::Model.client.client.cat.indices(index: 'translation*', h: [:index], format: 'json').count == 37
#       @models.delete('Content::Translation')
#     end
#
#     if Elasticsearch::Model.client.client.cat.indices(index: 'transliteration', h: [:index], format: 'json').count == 1
#       @models.delete('Content::Transliteration')
#     end
#
#     if Elasticsearch::Model.client.client.cat.indices(index: 'tafsir', h: [:index], format: 'json').count == 1
#       @models.delete('Content::TafsirAyah')
#     end
#
#     if Elasticsearch::Model.client.client.cat.indices(index: 'text-font', h: [:index], format: 'json').count == 1
#       @models.delete('Content::TafsirAyah')
#     end
#   rescue
#   end
#
#   return if @models.empty?
#   Parallel.each(@models, in_processes: 16, :progress => 'Doing stuff') do |model|
#     model = Kernel.const_get(model)
#     model.setup_index
#   end
# end
