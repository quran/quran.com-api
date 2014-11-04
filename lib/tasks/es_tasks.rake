namespace :es_tasks do
  desc "Deletes the index for current Elasticsearch"
  task delete_index: :environment do
    Searchable.delete_index
  end

  task setup_index: :environment do
    Searchable.setup_index
  end
end
