class Bucket::AyatController < ApplicationController
    def index
        
        # Set the variables
        @cardinalities, cut, @results = Hash.new, Hash.new, Hash.new


        # The range of which the ayahs to search
        range = params[:range].split("-")

        # Raise error whenever the range is more than 50
        # The database would take too long to process
        # It is suggested to do 10 ayah blocks though
        if (range.last.to_i - range.first.to_i) > 50
            raise APIValidation, "Range not set or invalid, use a string or an array (maximum 50 ayat per request), e.g. '1-3' or [ 1, 3 ]"
        end

         

        # Generate the keys for the given surah and range
        # keys = Quran::Ayah.fetch_ayahs(params[:surah], range.first, range.last)

        # Keys for the ayahs
        keys = Quran::Ayah.fetch_ayahs(params[:surah], range.first, range.last).map{|k| k.ayah_key}
        

        # For each key, need to setup the hash
        keys.each do |ayah_key|
            @results["#{ayah_key}".to_sym] = Hash.new
            @results["#{ayah_key}".to_sym][:ayah] = ayah_key.split(":").last.to_i
            @results["#{ayah_key}".to_sym][:surah] = params[:surah].to_i
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
        
        
        
        @cardinalities[:content].each do |row|
            if row.cardinality_type == 'n_ayah'
                join = "JOIN #{row.type}.#{row.sub_type} c using ( resource_id ) JOIN #{rowtype}.#{row.sub_type}_ayah n using ( #{row.sub_type}_id )";
            elsif row.cardinality_type == '1_ayah'
                join = "JOIN #{row.type}.#{row.sub_type} c using ( resource_id )";
            end
            if row.cardinality_type == 'n_ayah'
                Content::Resource
                .joins(join)
                .joins("JOIN quran.ayah using ( ayah_key )")
                .select("c.resource_id, quran.ayah.ayah_key, concat( '/', concat_ws( '/', r.type, r.sub_type, c.#{row.sub_type}_id ) ) url, content.resource.name")
                .where("content.resource.resource_id = ?", row.resource_id)
                .where("quran.ayah.ayah_key IN (?)", keys)
                .order("quran.ayah.surah_id , quran.ayah.ayah_num")
                .each do |ayah|
                    # @result[:content]["#{ayah.ayah_key}".to_sym] << {text: ayah.text, name: ayah.name}
                    @results["#{ayah.ayah_key}".to_sym][:content] << {text: ayah.text, name: ayah.name}
                end
            elsif row.cardinality_type == '1_ayah'
                Content::Resource
                .joins(join)
                .joins("join quran.ayah using ( ayah_key )")
                .select("c.*, content.resource.name")
                .where("content.resource.resource_id = ?", row.resource_id)
                .where("quran.ayah.ayah_key IN (?)", keys)
                .order("quran.ayah.surah_id , quran.ayah.ayah_num")
                .each do |ayah|
                    @results["#{ayah.ayah_key}".to_sym][:content] << {text: ayah.text, name: ayah.name}
                end

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





#                           left join quran.root qr on wr.root_id = qr.root_id