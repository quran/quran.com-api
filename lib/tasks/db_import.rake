# frozen_string_literal: true

namespace :db do
  task import: :environment do
    if ActiveRecord::Base.connection.tables.length > 28 && Chapter.count == 114
      puts 'Database says: You are good to go!'
      next
    else
      sh 'rake db:reset; true'
    end
  end
end
