class PagesController < ApplicationController
  def show
    @cardinalities, @results = Hash.new, Hash.new, Hash.new


    # default select the word font for the quran parameter
    params[:quran] ||= 1


    # Keys for the ayahs
    ayahs = Quran::Ayah.fetch_paged_ayahs(params[:id])

    keys = ayahs.map{|k| k.ayah_key}

    # For each key, need to setup the hash
    ayahs.each do |ayah|
        @results["#{ayah.ayah_key}".to_sym] = Hash.new
        @results["#{ayah.ayah_key}".to_sym][:ayah] = ayah.ayah_key.split(":").last.to_i
        @results["#{ayah.ayah_key}".to_sym][:text] = ayah.text
        @results["#{ayah.ayah_key}".to_sym][:surah_id] = ayah.surah_id
        @results["#{ayah.ayah_key}".to_sym][:content] = Array.new
        @results["#{ayah.ayah_key}".to_sym][:audio] = Hash.new
        @results["#{ayah.ayah_key}".to_sym][:quran] = Array.new
    end

    # cardinalities will be used to determine the kind of rendering to fetch
    @cardinalities = Content::Resource.fetch_cardinalities(params)

    # The cardinalities for the quran
    if @cardinalities.key? :quran
        @cardinalities[:quran].bucket_quran(params, keys).each do |ayah|
            #Rails.logger.debug( "each ayah #{ ap ayah }" )
            if ayah.kind_of?(Array)
                @results["#{ayah.first[:ayah_key]}".to_sym][:quran] = ayah
            else
                @results["#{ayah[:ayah_key]}".to_sym][:quran] = ayah
            end
        end
    end

    # Fetch the content corresponding to the the ayah keys and the content requested.
    if @cardinalities.key? :content
        @cardinalities[:content].each do |row|
            Content::Resource.bucket_content(row, keys).each do |ayah|
                #Rails.logger.debug( "aYAH #{ap ayah.as_json.deep_symbolize_keys}" )
                @results["#{ayah.ayah_key}".to_sym][:content] << { id: ayah.id, name: ayah.name, slug: ayah.slug, lang: ayah.lang, dir: ayah.dir }.merge( ayah.has_attribute?( :text ) ? { text: ayah.text } : {} ).merge( ayah.has_attribute?( :url ) ? { url: ayah.url } : {} )
            end
        end
    end

    if params.key? :audio
        Audio::File.bucket_audio(params, keys).each do |ayah|
            @results["#{ayah.ayah_key}".to_sym][:audio] = {
                ogg: 
                    {
                        url: ayah.ogg_url, 
                        duration: ayah.ogg_duration, 
                        mime_type: ayah.ogg_mime_type
                    }, 
                mp3: 
                    {
                        url: ayah.mp3_url, 
                        duration: ayah.mp3_duration, 
                        mime_type: ayah.mp3_mime_type
                    } 
            }
        end
    end

    # do some trimming
    keys.each do |ayah_key|
        @results["#{ayah_key}".to_sym].delete( :content ) if not @results["#{ayah_key}".to_sym][:content].length > 0
        @results["#{ayah_key}".to_sym].delete( :audio   ) if not @results["#{ayah_key}".to_sym][:audio].length > 0
    end



    @results = @results.values
  end
end
