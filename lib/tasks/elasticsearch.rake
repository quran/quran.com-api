# frozen_string_literal: true

namespace :elasticsearch do

  desc 'deletes all elasticsearch indices'
  task delete_indices: :environment do
    Qdc::Search::ContentIndex.remove_indexes rescue nil

    begin
      Verse.__elasticsearch__.delete_index!
    rescue Elasticsearch::Transport::Transport::Errors::NotFound => e
    end

    begin
      [Chapter, Juz, MuhsafPage].each do |model|
        model.__elasticsearch__.delete_index!
      end
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
    [Chapter, Juz, MuhsafPage].each do |model|
      model.__elasticsearch__.create_index!
    end

    Parallel.each([MuhsafPage, Chapter, Juz], in_processes: 3, progress: "Indexing chapters and juz data") do |model|
      model.import
    end

    puts "Importing ayah"

    if Rails.cache.read("verses_index").nil?
      Verse.import
      Rails.cache.write("verses_index", true, expires_in: 2.day.from_now)
    end

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
