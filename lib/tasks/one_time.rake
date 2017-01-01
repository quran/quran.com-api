namespace :one_time do
  task import_malayalam_data: :environment do
    language = Language.find_by_name('Malayalam')
    author = Author.where(name: "Tafhim al-Qur'an", url: "http://www.tafheem.net/").first_or_create
    resource_content =  ResourceContent.where(name: "Chapter Info", author: author, language: language).first_or_create(author_name: author.name, cardinality_type: '1_chapter_info', resource_type: 'Quran', sub_type: 'Chapter')
    resource_content.description = "Sayyid Abul Ala Maududi - Tafhim al-Qur'an - The Meaning of the Quran"

    chapter_names = JSON.parse(HTTParty.get('http://www.thafheem.net/assets/suranames.json').body)
    chapter_names.each do |item|
      chapter = Chapter.find(item['SuraID'])

      chapter.translated_names.where(language: language, name: item['MSuraName']).first_or_create

      info_data = JSON.parse(HTTParty.get("http://www.thafheem.net/thaf-api/preface/#{chapter.chapter_number}/M").body)

      short_text = info_data.first['PrefObj'].first['PrefaceText']
      text = info_data.first['PrefObj'].map do |section| "<h2>#{section['PrefaceSubTitle']}</h2> <p> #{section['PrefaceText'] }</p>" end.join('<br/>')
      chapter_info = chapter.chapter_infos.where(language: language).first_or_create

      chapter_info.text = text
      chapter_info.short_text = short_text
      chapter_info.source = "www.thafheem.net"
      chapter_info.resource_content = resource_content
      chapter_info.save
    end


    response = HTTParty.get('http://www.thafheem.net/thaf-api/rootwords/0')


    #word translitration
    word_trans = HTTParty.get('http://www.thafheem.net/thaf-api/ayawords/1/1-7/E')

  end

end



