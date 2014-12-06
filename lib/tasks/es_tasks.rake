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

  desc "recreates all elasticsearch indices"
  task recreate_index: :environment do
    ActiveRecord::Base.logger = Logger.new( STDOUT )
    Searchable.recreate_index
  end
end
