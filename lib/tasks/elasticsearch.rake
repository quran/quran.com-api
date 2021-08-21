# frozen_string_literal: true

namespace :elasticsearch do

  desc 'deletes all elasticsearch indices'
  task delete_indices: :environment do
    begin
      Qdc::Search::ContentIndex.remove_indexes
    rescue Elasticsearch::Transport::Transport::Errors::NotFound => e
    end

    begin
      Verse.__elasticsearch__.delete_index!
    rescue Elasticsearch::Transport::Transport::Errors::NotFound => e
    end

    begin
      Chapter.__elasticsearch__.delete_index!
    rescue Elasticsearch::Transport::Transport::Errors::NotFound => e
    end

    puts "Done"
  end

  desc 'reindex elasticsearch'
  task re_index: :environment do
    require 'parallel'

    ar_logger = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    index_start = Time.now
    Rails.logger.level = :warn

    Verse.__elasticsearch__.create_index!
    Chapter.__elasticsearch__.create_index!

    navigational_resources = [
      Chapter.includes(:translated_names),
      MushafPage,
      Juz,
      VerseKey.includes(:chapter)
    ]

    process_count = Rails.env.development? ? 1 : 3
    Parallel.each(navigational_resources, in_processes: process_count, progress: "Importing navigational data") do |model|
      model.bulk_import_with_variation
    end

    if Rails.cache.read("verses_index").nil?
      Verse.import
      Rails.cache.write("verses_index", true, expires_in: 1.day.from_now)
    end
    return
    #TODO: fix and import translation search

    puts "Setting up translation indexes"
    Qdc::Search::ContentIndex.setup_language_index_classes
    Qdc::Search::ContentIndex.setup_indexes

    Language.with_translations.each do |language|
      if Rails.cache.read("lang_#{language.id}_index").nil?
        Qdc::Search::ContentIndex.import_translation_for_language(language)
        Rails.cache.write("lang_#{language.id}_index", true, expires_in: 2.day.from_now)
      end
    end

    index_end = Time.now
    ActiveRecord::Base.logger = ar_logger
    Rails.logger.level = 0

    puts "Done #{Verse.__elasticsearch__.refresh_index!}"
    puts "Indexing started at #{index_start.strftime("%B %d, %Y %I:%M %P")}"
    puts "Indexing ended at #{index_end.strftime("%B %d, %Y %I:%M %P")}"
  end
end
