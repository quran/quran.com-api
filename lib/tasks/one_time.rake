namespace :one_time do
  task import_malayalam_data: :environment do
    require 'httparty'
    language = Language.find_by_name('Malayalam')

    source = DataSource.where(name: "Tafhim al-Qur'an", url: "http://www.tafheem.net/").first_or_create
    author = Author.where(name: "Sayyid Abul Ala Maududi").first_or_create
    resource_content = ResourceContent.where(name: "Chapter Info", author: author, language: language).first_or_create(author_name: author.name, cardinality_type: ResourceContent::CardinalityType::OneChapter, resource_type: ResourceContent::ResourceType::Content, sub_type: 'info')
    resource_content.data_source = source
    resource_content.description = "Sayyid Abul Ala Maududi - Tafhim al-Qur'an - The Meaning of the Quran"
    resource_content.save

    chapter_names = JSON.parse(HTTParty.get('http://www.thafheem.net/assets/suranames.json').body)
    chapter_names.each do |item|
      chapter = Chapter.find(item['SuraID'])

      chapter.translated_names.where(language: language, name: item['MSuraName']).first_or_create

      info_data = JSON.parse(HTTParty.get("http://www.thafheem.net/thaf-api/preface/#{chapter.chapter_number}/M").body)

      short_text = info_data.first['PrefObj'].first['PrefaceText']
      text = info_data.first['PrefObj'].map do |section|
        "<h2>#{section['PrefaceSubTitle']}</h2> <p> #{section['PrefaceText'] }</p>"
      end.join('<br/>')
      chapter_info = chapter.chapter_infos.where(language: language).first_or_create

      chapter_info.text = text
      chapter_info.short_text = short_text
      chapter_info.source = "www.thafheem.net"
      chapter_info.resource_content = resource_content
      chapter_info.save
    end

    resource_content = ResourceContent.where(name: "Word translation", author: author, language: language).first_or_create(author_name: author.name, cardinality_type: ResourceContent::CardinalityType::OneWord, resource_type: ResourceContent::ResourceType::Content, sub_type: ResourceContent::SubType::Translation)
    resource_content.data_source = source
    resource_content.description = "Word-by-word translation in Malayalam language by Sayyid Abul Ala Maududi"
    resource_content.save
  end

  task :import_tamil do

    language = Language.find_by_name('Tamil')
    source = DataSource.where(name: "Tafhim al-Qur'an", url: "http://truevisionmedia.org/").first_or_create
    author = Author.where(name: "Sayyid Abul Ala Maududi").first_or_create
    resource_content = ResourceContent.where(name: "Chapter Info", author: author, language: language).first_or_create(author_name: author.name, cardinality_type: ResourceContent::CardinalityType::OneChapter, resource_type: ResourceContent::ResourceType::Content, sub_type: 'info')
    resource_content.data_source = source
    resource_content.description = "Sayyid Abul Ala Maududi - Tafhim al-Qur'an - The Meaning of the Quran"
    resource_content.save

    1.upto(114) do |number|
      chapter = Chapter.find(number)

      chapter_info = chapter.chapter_infos.where(language: language).first_or_create
      chapter_info.text = File.open("data/tamil_info/#{number}.html").read.to_s.strip
      chapter_info.source ="Sayyid Abul Ala Maududi - Tafhim al-Qur'an - The Meaning of the Quran"
      chapter_info.resource_content = resource_content
      chapter_info.save
    end
  end

  task import_urdu_data: :environment do
    language = Language.find_by_name('Urdu')

    source = DataSource.where(name: "Tafhim al-Qur'an", url: "http://www.tafheemulquran.net/").first_or_create
    author = Author.where(name: "Sayyid Abul Ala Maududi").first_or_create
    resource_content = ResourceContent.where(name: "Chapter Info", author: author, language: language).first_or_create(author_name: author.name, cardinality_type: ResourceContent::CardinalityType::OneChapter, resource_type: ResourceContent::ResourceType::Content, sub_type: 'info')
    resource_content.data_source = source
    resource_content.description = "Sayyid Abul Ala Maududi - Tafhim al-Qur'an - The Meaning of the Quran"
    resource_content.save

    1.upto(114) do |number|
      chapter = Chapter.find(number)
      chapter_number = number.to_s.rjust(3, '0')

      chapter_info = chapter.chapter_infos.where(language: language).first_or_create

      chapter_info.text = File.open("data/urdu_final/#{chapter_number}.html").read.to_s.strip
      chapter_info.source = "سید ابو اعلیٰ مودودیؒ -  تفہیم القرآن"
      chapter_info.resource_content = resource_content
      chapter_info.save
    end
  end

  task :add_chapter_translated_name do
    #Create translated name of languages
    Language.find_each do |lan|
      lan.translated_names.where(language: Language.default, name: lan.name).first_or_create
    end

    [['Chinese', 'chinese.json'], ['French', 'france.json'], ['Urdu', 'urdu.json'], ['Azeri', 'azirbijan.json'],
     ['Bosnian', 'bonski.json'], ['Dutch', 'neatherland.json'], ['Russian', 'ru.json'], ['Spanish', 'spanish.json'],
     ['Swedish', 'swedish.json'], ['Indonesian', 'id.json']
    ].each do |item|
      lang, file_name = item
      language = Language.find_by_name(lang)

      json = JSON.parse(File.open("data/translated_names/#{file_name}", 'r').read)

      json.each do |c|
        name = c['name'].to_s.split(',').first
        chapter = Chapter.find_by_chapter_number(c['id'])
        chapter.translated_names.where(language: language).first_or_create.update_attributes(name: name)
      end
    end
  end
end

=begin

agent = Mechanize.new

1.upto(114).each do |chapter_number|
  chapter_number = chapter_number.to_s.rjust(3, '0')
  url = "http://www.tafheemulquran.net/1_Tafheem/Suraes/#{chapter_number}/S#{chapter_number}.html"
  info = agent.get(url).search-v2("#intro td p").inner_html
  File.open("data/urdu_info/#{chapter_number}.html", 'wb') do |file|
    file << info
  end

  frag.xpath("//span[@class='style24']").each do |node|
    node.name = 'h2'
    node.remove_attribute 'class'
  end

  frag.xpath('/html/body/text()').wrap('<p/>')

  text = File.open('data/urdu_info/002.html').read
  frag = Nokogiri::HTML(text)


end

def is_blank?(node)
  (node.text? && node.content.strip == '') || (node.element? && node.name == 'br')
end

def all_children_are_blank?(node)
  node.children.all?{|child| is_blank?(child) }
  # Here you see the convenience of monkeypatching... sometimes.
end


1.upto(114).each do |n|
n = n.to_s.rjust(3, '0')

frag = Nokogiri::HTML(File.open("data/urdu_info/#{n}.html").read)

#1 move style24 to body
frag.css('.style24').each do |node|
  while (node.parent && node.parent.name != 'body') do
    p = node.parent
    puts "replaces #{p.name}"
    p.replace(p.children.to_html.to_s.strip)
    node = p
  end
end

#replace all tag expect span.style24
frag.search-v2('//*/*').each do |node|
  next if ['a', 'body'].include?(node.name) || (node.name == 'span' && ['style24', 'style41'].include?(node.attr("class")))

  puts "replacing #{node.name}"
  node.replace(node.content.to_s.strip)
end

#replace span with h2
frag.xpath("//span[@class='style24']").each do |node|
  node.name = 'h2'
  node.remove_attribute 'class'
end

#update style41 to indopak
frag.xpath("//span[@class='style41']").each do |node|
  node.set_attribute 'class', 'ar indopak'
end

#wrap all text with p
frag.xpath('/html/body/text()').wrap('<p/>')

#remove empty
frag.css("p").find_all{|p| all_children_are_blank?(p) }.each do |p|
  p.remove
end

File.open "data/urdu_fixed6/#{n}.html", 'wb' do |file| file << frag.search-v2('body').children.to_html end
end

#Tamil
1.upto(114) do |number|
      content = agent.get("http://truevisionmedia.org/ift-chennai/tafheem-tamil/intro/intro3.htm").search-v2("body p")[1].to_html

      File.open("data/tamil_info/#{number}.html", 'wb') do |file| file << content
      end
    end
=end