class SearchController < ApplicationController

    def query

        # Init the config hash and the output
        config, @output = Hash.new, Hash.new

        query = params[:q]
        page  = ( params[:page] || "1" ).to_i
        size  = ( params[:size] || "20" ).to_i

        # if the query is pure Arabic, then we should only match against ayah text and tafsir types
        config[:types] ||= [ "text", "text_token", "text_stem", "text_lemma", "text_root", "tafsir" ] if query =~ /^(?:\s*[\p{Arabic}\p{Diacritic}]+\s*)+$/
        # if the query is pure ASCII, then it's either transliteration or a translation (probably english)
        config[:types] ||= [ "transliteration", "translation"] if query =~ /^(?:\s*\p{ASCII}+\s*)+$/
        # if the query is not pure ASCII and not Arabic, then it has to be a translation
        config[:types] ||= [ "translation" ] # this is what happens when we encounter an umlaut, for example

        matched_parents = Quran::Ayah.matched_parents( query, config[:types] )

        # Array of ayah keys to use to search for the child model
        array_of_ayah_keys = matched_parents.map{|r| r._source.ayah_key}

        # Search child models, i.e. found what hit against the set of ayah_keys above^
        matched_children = ( OpenStruct.new Quran::Ayah.matched_children( query, config[:types], array_of_ayah_keys ) ).responses

        # Init results of matched parent and child array
        results = Array.new

        matched_parents.results.each_with_index do |ayah, index|
            # Rails.logger.info ayah.to_hash
            best = Array.new

            score = 0
            matched_children[index]["hits"]["hits"].each do |hit|
                best.push({
                    # name: hit["_source"]["resource"]["name"], 
                    # slug: hit["_source"]["resource"]["slug"], 
                    # type: hit["_source"]["resource"]["type"], 
                    highlight: hit["highlight"]["text"].first, 
                    score: hit["_score"],
                    id: hit["_source"]["resource_id"],
                    text: hit["_source"]["text"]
                })
                score = hit["_score"] if hit["_score"] > score
            end


            ayah = {
                key: ayah._source.ayah_key,
                ayah: ayah._source.ayah_num,
                surah: ayah._source.surah_id,
                index: ayah._source.ayah_index,
                score: score, #ayah._score,
                match: {
                    hits: matched_children[index]["hits"]["total"],
                    # testing: matched_children[index]["hits"]["hits"], #use this to test the output
                    best: best

                },
                bucket: {
                    surah: ayah._source.surah_id,
                    quran: {
                        text: ayah._source.text
                    },
                    ayah: ayah._source.ayah_num

                }
            }
            results.push(ayah)
        end

        # NOTE due to the technical complexities of searching both the 'parent' set then subsequent 'child' sets
        # and merging the two result sets above, we manually do these two steps here:
        # a) capture the entire set of parent ayahs (which may be more then the desired pagination size), and
        # b) sort them by the highest scores of their child matches
        results.sort! { |a,b| b[:score] <=> a[:score] }
        results = results[ page - 1, size ]

        # NOTE we also had to disable field norms in the relevance scoring (see the NOTE in config/elasticsearch/mappings.yml).
        # it was assigned a value of '1' to some results when it should have been much less than 1 (seems like a bug).
        # discovering this issue took me all day :( but alhamdulelah :)

        render json: results

    end
end
