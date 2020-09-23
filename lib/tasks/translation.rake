# frozen_string_literal: true

namespace :translation do
  task import: :environment do
    # NOTE: place file(translation.txt) in tasks directory, fill these variables and ran the rake task to import translation. Each line should have single verse translation in order
    # Its one time operation, index and performance don't count

    author_name = 'Mustafa Khattab'
    localized_name = 'Mustafa Khattab'
    language = Language.find_by(iso_code: 'en') # English
    data_source = DataSource.where(name: 'Quran.com').first_or_create

    author = Author.where(name: author_name).first_or_create
    if localized_name
      author.translated_names.where(language: language).first_or_create(name: localized_name)
    end

    resource_content = ResourceContent.where(data_source: data_source, cardinality_type: ResourceContent::CardinalityType::OneVerse, sub_type: ResourceContent::SubType::Translation, resource_type: ResourceContent::ResourceType::Content, language: language, author: author).first_or_create
    resource_content.author_name = author.name
    resource_content.name = author.name
    resource_content.language_name = language.name
    resource_content.approved = false # varify and approve after importing
    resource_content.slug = "#{language.iso_code}_#{author.name.underscore.gsub(/(\s)+/, ' ').gsub(' ', '_')}"
    resource_content.save

    lines = []
    File.open("#{Rails.root}/lib/tasks/translation.txt", 'r').each_line do |line|
      lines << line.strip
    end

    if Verse.count != lines.count
      raise("Invalid file, file should have #{Verse.count} lines")
    end

    Verse.unscoped.order('verse_index asc').each_with_index do |verse, i|
      trans = verse.translations.where(language: language, resource_content: resource_content).first_or_create
      trans.text = lines[i]
      trans.language_name = language.name
      trans.resource_name = resource_content.name
      trans.save
    end

    puts "Done importing translation. Resource id: #{resource_content.id}"
  end
end
