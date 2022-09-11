xml.instruct!
xml.rss :version => "2.0", "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd" do
  xml.channel do
    xml.title "Quran.com Podcast"
    xml.itunes:owner do
      xml.tag! "itunes:email", "salam@quran.com"
    end
    xml.tag! "itunes:author", "Quran.com"
    xml.link "http://localhost:3000/api/v4/rss"
    xml.description "Quran.com podcast"
    xml.language "en-us"
    xml.image do
      xml.link "http://localhost:3000/api/v4/rss"
      xml.title "Quran.com Podcast"
      xml.url "https://raw.githubusercontent.com/quran/quran.com-frontend-next/master/public/logo.png"
    end

    @episodes.each do |episode|
      xml.item do
        xml.enclosure :type => "audio/mpeg", :url => episode.audio_url
        xml.title episode.chapter_name
        xml.description episode.reciter_name
       end
     end
  end
end
