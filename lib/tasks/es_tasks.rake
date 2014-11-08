namespace :es_tasks do
  desc "Deletes the index for current Elasticsearch"
  task delete_index: :environment do
    Searchable.delete_index
  end

  desc "creates the index (assumes a blank slate, ie: run delete_index first if it already exists"
  task setup_index: :environment do
    ActiveRecord::Base.logger = Logger.new( STDOUT )
    Searchable.setup_index
  end
end
