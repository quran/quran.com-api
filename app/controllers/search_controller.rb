class SearchController < ApplicationController

    def query

        # Init the config hash and the output
        config, @output = Hash.new, Hash.new

        query = params[:q]

        # Set the configs
        config[:types] ||= [ "quran.text", "quran.token", "quran.stem", 
                            "quran.lemma", "quran.root", "content.tafsir" ] if  query =~ /^(?:\s*[\p{Arabic}\p{Diacritic}]+\s*)+$/
        config[:types] ||= [ "content.transliteration", "content.translation"] if query =~ /^(?:\s*\p{ASCII}+\s*)+$/;
        

        
        matched_parents = Quran::Ayah.search(query, params[:page], params[:size], config[:types])

        # Array of ayah keys to use to search for the child model
        array_of_ayah_keys = matched_parents.map{|r| r._source.ayah_key}




        
        # Search child models
        # matched_children = ( OpenStruct.new Content::Translation.matched_children(query, array_of_ayah_keys) ).responses
        

        # # Rails.logger.ap matched_children
        
        # # Init results of matched parent and child array
        # results = Array.new


        # matched_parents.results.each_with_index do |ayah, index|
        #     # Rails.logger.info ayah.to_hash
        #     best = Array.new

        #     matched_children[index]["hits"]["hits"].each do |hit|
        #         best.push({
        #             name: hit["_source"]["resource"]["name"], 
        #             slug: hit["_source"]["resource"]["slug"], 
        #             type: hit["_source"]["resource"]["type"], 
        #             highlight: hit["highlight"]["text"].first, 
        #             score: hit["_score"],
        #             id: hit["_source"]["resource_id"],
        #             text: hit["_source"]["text"]
        #         })
        #     end


        #     ayah = {
        #         key: ayah._source.ayah_key,
        #         ayah: ayah._source.ayah_num,
        #         surah: ayah._source.surah_id,
        #         index: ayah._source.ayah_index,
        #         score: ayah._score,
        #         match: {
        #             hits: matched_children[index]["hits"]["total"],
        #             # testing: matched_children[index]["hits"]["hits"], #use this to test the output
        #             best: best

        #         },
        #         bucket: {
        #             surah: ayah._source.surah_id,
        #             quran: {
        #                 text: ayah._source.text
        #             },
        #             ayah: ayah._source.ayah_num

        #         }
        #     }
        #     results.push(ayah)
        # end

        # return results

        
    	

    	
    end
end
