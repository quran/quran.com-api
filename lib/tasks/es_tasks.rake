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
    ActiveRecord::Base.logger = Logger.new( STDOUT )
    Searchable.setup_index
  end
end
