xml.instruct!
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Quran.com Podcast"
    xml.link "http://localhost:3000/api/v4/rss"
    xml.itunes:owner do
      xml.itunes "salam@quran.com"
    end
    xml.image do
      xml.link "http://localhost:3000/api/v4/rss"
      xml.title "Quran.com Podcast"
      xml.url "https://raw.githubusercontent.com/quran/quran.com-frontend-next/master/public/logo.png"
    end
    xml.description "Quran.com podcast"

    @episodes.each do |episode|
      xml.item do
        xml.enclosure episode.audio_url
        xml.title episode.chapter_name
        xml.description episode.reciter_name
        xml.guid episode.id
       end
     end
  end
end
