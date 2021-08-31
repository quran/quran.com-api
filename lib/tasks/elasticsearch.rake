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
    options = {}

    opts = OptionParser.new
    opts.banner = "Usage: rake add [options]"
    opts.on("-q", "--query ARG") { |debug| options[:debug_queries] = debug }
    args = opts.order!(ARGV) {}
    opts.parse!(args)

    ar_logger = ActiveRecord::Base.logger

    if options[:debug_queries]
      Rails.logger.level = :warn
      ActiveRecord::Base.logger = Logger.new(STDOUT)
    else
      ActiveRecord::Base.logger = nil
    end

    index_start = Time.now

    Verse.__elasticsearch__.create_index!
    Chapter.__elasticsearch__.create_index!

    navigational_resources = [
      Chapter.includes(:translated_names),
      MushafPage,
      Juz,
      VerseKey.includes(:chapter).order("verse_index ASC")
    ]

    navigational_resources.each do |model|
      model.bulk_import_with_variation
    end

    puts "Importing verses"
    Verse.includes(:char_words).import

    puts "Setting up translation indexes"
    Qdc::Search::ContentIndex.setup_language_index_classes
    Qdc::Search::ContentIndex.setup_indexes

    Language.with_translations.order('translations_count DESC').each do |language|
      puts "importing translations for #{language.name}"
      Qdc::Search::ContentIndex.import_translation_for_language(language)
    end

    index_end = Time.now
    ActiveRecord::Base.logger = ar_logger
    Rails.logger.level = 0

    puts "Done #{Verse.__elasticsearch__.refresh_index!}"
    puts "Indexing started at #{index_start.strftime("%B %d, %Y %I:%M %P")}"
    puts "Indexing ended at #{index_end.strftime("%B %d, %Y %I:%M %P")}"
  end
end
