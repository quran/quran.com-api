namespace :translation do
  task import: :environment do
    #NOTE: place file(translation.txt) in rake directory, fill these variables and ran the rake task to import translation. Each line should have single verse translation in order
    # Its one time operation, index and performance don't count

    author_name = "AbdolMohammad Ayati"
    localized_name="Абдулмуҳаммади Оятӣ"
    language = Language.find(160) #Tajik

    author = Author.create(name: author_name)
    if localized_name
      author.translated_names.where(language: language).first_or_create(name: localized_name)
    end

    resource_content = ResourceContent.where(cardinality_type: '1_ayah', sub_type: 'translation', language: language, author: author, author_name: author.name).first_or_create
    resource_content.approved = false #varify and approve after importing
    resource_content.save

    lines = []
    File.open("#{Rails.root}/lib/tasks/translation.txt", "r").each_line do |line|
      lines << line.strip
    end

    if Verse.count != lines.count
      raise("Invalid file, file should have #{Verse.count} lines")
    end

    Verse.order('id asc').each_with_index do |verse, i|
      verse.translations.where(language: language, resource_content: resource_content).first_or_create(text: lines[i])
    end
  end
end
