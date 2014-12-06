# vim: ts=4 sw=4 expandtab
class SearchController < ApplicationController
    def query
        # Init the config hash and the output
        config, @output = Hash.new, Hash.new

        # Init the start time
        start_time = Time.now

        query = params[:q]
        page  = ( params[:page] || "1" ).to_i
        size  = ( params[:size] || "20" ).to_i

        # TODO ditch this types switch and instead set the index property to [ text*, tafsir ], trans*, or translation-* according to whatever is proper
        # if the query is pure Arabic, then we should only match against ayah text and tafsir types
        # if the query is pure ASCII, then it's either transliteration or a translation (probably english)
        # if the query is not pure ASCII and not Arabic, then it has to be a translation

        config[:types] ||= [ "text*", "tafsir" ] if query =~ /^(?:\s*[\p{Arabic}\p{Diacritic}]+\s*)+$/
        config[:types] ||= [ "transl*"] if query =~ /^(?:\s*\p{ASCII}+\s*)+$/ # TODO some additional control to favor translation-en in this case (since it's pure ASCII)
        config[:types] ||= [ "translation-*" ] # this is what happens when we encounter an umlaut, for example

        matched_parents = Quran::Ayah.matched_parents( query, config[:types] )
        ayah_keys = matched_parents.map { |tup| tup[0] }

        # Search child models, i.e. found what hit against the set of ayah_keys above^
        matched_children = ( OpenStruct.new Quran::Ayah.matched_children( query, config[:types], ayah_keys ) ).responses


        # Init results of matched parent and child array
        results = Array.new

        matched_parents.each_with_index do |tup, index|
            source = tup[1]

            best = Array.new

            score = 0
            matched_children[index]["hits"]["hits"].each do |hit|
                best.push( {
                    highlight: hit["highlight"]["text"].first,
                    score:     hit["_score"],
                    id:        hit["_source"]["resource_id"],
                    text:      hit["_source"]["text"]
                } )
                score = hit["_score"] if hit["_score"] > score
            end

            ayah = {
                key:   source['ayah_key'],
                ayah:  source['ayah_num'],
                surah: source['surah_id'],
                index: source['ayah_index'],
                score: score, #ayah._score,
                match: {
                    hits: matched_children[index]["hits"]["total"],
                    best: best
                },
                bucket: {
                    surah: source['surah_id'],
                    quran: {
                        text: source['text']
                    },
                    ayah:  source['ayah_num']
                }
            }
            results.push(ayah)
        end

        # NOTE due to the technical complexities of searching both the 'parent' set then subsequent 'child' sets
        # and merging the two result sets above, we manually do these two steps here:
        # a) capture the entire set of parent ayahs (which may be more then the desired pagination size), and
        # b) sort them by the highest scores of their child matches
        results.sort! { |a,b| b[:score] <=> a[:score] }
        results = results[ ( page - 1 ) * size, size ]

        # NOTE we also had to disable field norms in the relevance scoring (see the NOTE in config/elasticsearch/mappings.yml).
        # it was assigned a value of '1' to some results when it should have been much less than 1 (seems like a bug).
        # discovering this issue took me all day :( but alhamdulelah :)

        # End time for query
        end_time = Time.now

        to_render = {
            query: params[:q], 
            hits: matched_parents.results.total, 
            took: (end_time-start_time), 
            page: page, 
            size: size, 
            returned_size: results.length, 
            results: results
        }

        render json: to_render
    end
end
