class AyatController < ApplicationController
  def index
        # Set the variables
        @cardinalities, cut, @results = Hash.new, Hash.new, Hash.new


        # The range of which the ayahs to search
        if params[:range] 
            range = params[:range].split("-")
        elsif params[:from] && params[:to]
            range = [params[:from] , params[:to]]
        else
            ["1", "10"]
        end
                

        # Raise error whenever the range is more than 50
        # The database would take too long to process
        # It is suggested to do 10 ayah blocks though
        if (range.last.to_i - range.first.to_i) > 50
            raise APIValidation, "Range not set or invalid, use a string or an array (maximum 50 ayat per request), e.g. '1-3' or [ 1, 3 ]"
        end

        # Generate the keys for the given surah and range
        # keys = Quran::Ayah.fetch_ayahs(params[:surah], range.first, range.last)

        # Keys for the ayahs
        keys = Quran::Ayah.fetch_ayahs(params[:surah_id], range.first, range.last).map{|k| k.ayah_key}
        # For each key, need to setup the hash
        keys.each do |ayah_key|
            @results["#{ayah_key}".to_sym] = Hash.new
            @results["#{ayah_key}".to_sym][:ayah] = ayah_key.split(":").last.to_i
            @results["#{ayah_key}".to_sym][:surah] = params[:surah_id].to_i
            @results["#{ayah_key}".to_sym][:content] = Array.new
            @results["#{ayah_key}".to_sym][:audio] = Hash.new
            @results["#{ayah_key}".to_sym][:quran] = Array.new
        end

        # cardinalities will be used to determine the kind of rendering to fetch
        @cardinalities = Content::Resource.fetch_cardinalities(params)

        # The cardinalities for the quran
        @cardinalities[:quran].bucket_results_quran(params, keys).each do |ayah|
            if ayah.kind_of?(Array)
                @results["#{ayah.first[:ayah_key]}".to_sym][:quran] = ayah
            else
                @results["#{ayah[:ayah_key]}".to_sym][:quran] = ayah
            end
        end

        # Fetch the content corresponding to the the ayah keys and the content requested.
        @cardinalities[:content].each do |row|
            Content::Resource.bucket_results_content(row, keys).each do |ayah|
                @results["#{ayah.ayah_key}".to_sym][:content] << { name: ayah.name }.merge( ayah.has_attribute?( :text ) ? { text: ayah.text } : {} ).merge( ayah.has_attribute?( :url ) ? { url: ayah.url } : {} )
            end
        end

        Audio::File.fetch_audio_files(params, keys).each do |ayah|
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

        @results = @results.values
    end 
end
