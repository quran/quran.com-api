# frozen_string_literal: true

namespace :elasticsearch do

  desc "deletes all elasticsearch indices"
  task delete_indices: :environment do
    Verse.__elasticsearch__.delete_index!
  end

  desc "reindex elasticsearch"
  task re_index: :environment do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    Verse.__elasticsearch__.import force: true
  end

end
