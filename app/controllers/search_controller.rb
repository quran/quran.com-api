# vim: ts=4 sw=4 expandtab
# DONE 1. set analyzers for every language
# TODO 1.a. actually configure the analyzer so that certain words are protected (like allah, don't want to stem that). hopefully an alternate solution is available, so this isn't priority until the steps below are done.
# TODO 2. determine the language of the query (here)
# TODO 3. apply weights to different types of indices e.g. text > tafsir
# TODO 4. break down fields into analyzed and unanalyzed and weigh them
#
# NEW
# TODO 1. determine language
#      2. refactor query accordingly
#      3. refactor code
#      4. refine search, optimize for performance
require 'awesome_print'
class SearchController < ApplicationController
    def self.query params = {}, headers = {}, session = {}
        query = params[:q]
        page  = [ ( params[:page] or params[:p] or 1 ).to_i, 1 ].max
        size  = [ [ ( params[:size] or params[:s] or 20 ).to_i, 20 ].max, 40 ].min # sets the max to 40 and min to 20
        # Determining query language
        # - Determine if Arabic (regex); if not, determine boost using the following...
        #   a. Use Accept-Language HTTP header
        #   b. Use country-code to language mapping (determine country code from geolocation)
        #   c. Use language-code from user application settings (should get at least double priority to anything else)
        #   d. Fallback to boosting English if nothing was determined from above and the query is pure ascii


        Rails.logger.info "headers #{ ap headers }"
        Rails.logger.info "session #{ ap session }"
        Rails.logger.info "params #{ ap params }"

        search_params = {}
        boost_language_code = {}
        most_fields_fields_val = []

        if query =~ /^(?:\s*[\p{Arabic}\p{Diacritic}\p{Punct}\p{Digit}]+\s*)+$/
            search_params.merge!( {
                index: [ 'text-font', 'tafsir' ],
                body: {
                    indices_boost: {
                        :"text-font" => 4,
                        :"tafsir"    => 1
                    }
                }
            } )
            most_fields_fields_val = [ 'text^5', 'text.lemma^4', 'text.stem^3', 'text.root^1.5', 'text.lemma_clean^3', 'text.stem_clean^2', 'text.ngram^2', 'text.stemmed^2' ]
        else
            most_fields_fields_val = [ 'text^1.6', 'text.stemmed' ]

            # TODO filter for langs that have translations only

            # handle the accept-language http header
            if headers[ 'Accept-Language' ]
                Rails.logger.info "accept language headers #{ ap headers[ 'Accept-Language' ] }"
                # e.g. "en-US,en;q=0.8,ar;q=0.6"
                headers[ 'Accept-Language' ].split( /,/ ).map { |str| str.split( /;/ )[0].split( /-/ )[0] }.each do |lc|
                    if not boost_language_code[ lc ]
                        boost_language_code[ lc ] = 4
                    else
                        boost_language_code[ lc ] = boost_language_code[ lc ] + 1
                    end
                end
            end

            # handle the country code determined from their geolocation
            if session[ 'country_code' ]
                # TODO this is NOT how we're going to do this
                country_to_language_code = {}
                File.open( '/usr/share/i18n/SUPPORTED' ).each do |line|
                    line.gsub! /[ .@].*/, ''
                    lc, cc = line.split( /_/ )
                    country_to_language_code[ cc ] = lc if not country_to_language_code[ cc ]
                end

                if country_to_language_code.key? session[ 'country_code' ]
                    lc = country_to_language_code[ session[ 'country_code' ] ]
                    if not boost_language_code[ lc ]
                        boost_language_code[ lc ] = 4
                    else
                        boost_language_code[ lc ] = boost_language_code[ lc ] + 1
                    end
                end
            end

            # handle the language code if say sometime in the future we allow users
            # to specify their preferred language directly in their settings
            if session[ 'language_code' ]
                lc = session[ 'language_code' ]
                if boost_language_code.keys.length > 0
                    # just give it double score because they chose it explicitly
                    boost_language_code[ lc ] = boost_language_code.values.max * 2
                else
                    boost_language_code[ lc ] = 4
                end
            end

            # fallback to doubling the boost on english queries if we haven't gotten anywhere
            # using the above strategies and the query is pure ascii
            if boost_language_code.keys.length == 0 and query =~ /^(?:\s*\p{ASCII}+\s*)+$/
                boost_language_code[ 'en' ] = 4
            end

            indices_boost = {}
            boost_language_code.keys.each do |lc|
                indices_boost[ :"translation-#{lc}" ] = boost_language_code[ lc ]
            end

            search_params.merge!( {
                index: [ 'trans*' ],
                body: {
                    indices_boost: indices_boost
                }
            } )
        end

        search_params.merge!( {
            explain: true,
            type: 'data',
        } )

        search_params[:body].merge!( {
            highlight: {
                fields: {
                    text: {
                        type: 'fvh',
                        matched_fields: [ 'text.root', 'text.stem_clean', 'text.lemma_clean', 'text.stemmed' ],
                        ## NOTE this set of commented options highlights up to the first 100 characters only but returns the whole string
                        #fragment_size: 100,
                        #fragment_offset: 0,
                        #no_match_size: 100,
                        #number_of_fragments: 1
                        number_of_fragments: 0
                    }
                },
                tags_schema: 'styled',
                #force_source: true
            },
            query: {
                bool: {
                    must: [ {
                    ## NOTE leaving this in for future reference
                    #    term: {
                    #        :'ayah.surah_id' => '2'
                    #    }
                    #}, {
                        multi_match: {
                            type: 'most_fields',
                            query: query,
                            fields: most_fields_fields_val,
                            minimum_should_match: '3<62%'
                        }
                    } ]
                }
            },
            _source: [ "text", "ayah.*" ],
            fields: [ 'ayah.ayah_key', 'ayah.ayah_num', 'ayah.surah_id', 'ayah.ayah_index', 'text' ],
        } )

        #return search_params

        by_key = {}

        window = ( size * 1.5 ).to_i
        start = 0

        loop do
            from = ( page - 1 ) * window + start
            start = start + window
            search_params.merge!( {
                from: from,
                size: window
            } )

            break if by_key.keys.length >= size

            begin
                results = Quran::Ayah.__elasticsearch__.client.search( search_params )
            rescue Elasticsearch::Transport::Transport::Errors::BadRequest => e
                return e
            else
                Rails.logger.debug( ap by_key )
                Rails.logger.debug( "from #{ from } window #{ window } size #{size} length #{ by_key.keys.length } results #{ results[ 'hits' ][ 'hits' ].length } " )
                #return results
#                return "oops"
            end

            break if results[ 'hits' ][ 'hits' ].length == 0

            # r['hits']['total']
            #return results

            results[ 'hits' ][ 'hits' ].each do |hit|
                _source    = hit[ '_source' ]
                _score     = hit[ '_score' ]
                _highlight = ( hit.key?( 'highlight' ) && hit[ 'highlight' ].key?( 'text' ) ) ? hit[ 'highlight' ][ 'text' ].first : ''
                ayah       = OpenStruct.new _source[ 'ayah' ]

                # break out of this enumerable if we already gathered 20 ayahs, for example
                break if by_key.keys.length == size and by_key[ ayah.ayah_key ] == nil

                by_key[ ayah.ayah_key ] = {
                    _index: hit[ '_index' ],
                    _id: hit[ '_id' ],
                    key:   ayah.ayah_key,
                    ayah:  ayah.ayah_num,
                    surah: ayah.surah_id,
                    index: ayah.ayah_index,
                    score: 0,
                    match: {
                        hits: 0,
                        best: []
                    },
                    bucket: {
                        surah: ayah.surah_id,
                        ayah:  ayah.ayah_num,
                        quran: {
                            text: nil
                        }
                    }
                } if by_key[ ayah.ayah_key ] == nil

                result = by_key[ ayah.ayah_key ]

                result[:score]        = _score if _score > result[:score]
                result[:match][:hits] = result[:match][:hits] + 1
                result[:match][:best].push( {
                    text:      _source[ 'text' ],
                    score:     _score,
                    highlight: _highlight
                } )
            end
        end

        return by_key.keys.sort { |a,b| by_key[ b ][ :score ] <=> by_key[ a ][ :score ] } .map { |k| by_key[ k ] }
    end

    def query
        render json: SearchController.query( params, request.headers, session )
        return
        # Init the config hash and the output
        config, @output = Hash.new, Hash.new

        query = params[:q]

        results = Quran::Ayah.search( query )

        render json: results

#        page  = ( params[:page] || "1" ).to_i
#        size  = ( params[:size] || "20" ).to_i
#
#        # TODO ditch this types switch and instead set the index property to [ text*, tafsir ], trans*, or translation-* according to whatever is proper
#        # if the query is pure Arabic, then we should only match against ayah text and tafsir types
#        # if the query is pure ASCII, then it's either transliteration or a translation (probably english)
#        # if the query is not pure ASCII and not Arabic, then it has to be a translation
#
#        config[:types] ||= [ "text*", "tafsir" ] if query =~ /^(?:\s*[\p{Arabic}\p{Diacritic}]+\s*)+$/
#        config[:types] ||= [ "transl*"] if query =~ /^(?:\s*\p{ASCII}+\s*)+$/ # TODO some additional control to favor translation-en in this case (since it's pure ASCII)
#        config[:types] ||= [ "translation-*" ] # this is what happens when we encounter an umlaut, for example
#
#        matched_parents = Quran::Ayah.matched_parents( query, config[:types] )
#        ayah_keys = matched_parents.map { |tup| tup[0] }
#
#        # Search child models, i.e. found what hit against the set of ayah_keys above^
#        matched_children = ( OpenStruct.new Quran::Ayah.matched_children( query, config[:types], ayah_keys ) ).responses
#
#        # Init results of matched parent and child array
#        results = Array.new
#
#        matched_parents.each_with_index do |tup, index|
#            source = tup[1]
#            best = Array.new
#
#            score = 0
#            matched_children[index]["hits"]["hits"].each do |hit|
#                best.push( {
#                    highlight: hit["highlight"]["text"].first,
#                    score:     hit["_score"],
#                    id:        hit["_source"]["resource_id"],
#                    text:      hit["_source"]["text"]
#                } )
#                score = hit["_score"] if hit["_score"] > score
#            end
#
#            ayah = {
#                key:   source['ayah_key'],
#                ayah:  source['ayah_num'],
#                surah: source['surah_id'],
#                index: source['ayah_index'],
#                score: score, #ayah._score,
#                match: {
#                    hits: matched_children[index]["hits"]["total"],
#                    best: best
#                },
#                bucket: {
#                    surah: source['surah_id'],
#                    quran: {
#                        text: source['text']
#                    },
#                    ayah:  source['ayah_num']
#                }
#            }
#            results.push(ayah)
#        end
#
#        # NOTE due to the technical complexities of searching both the 'parent' set then subsequent 'child' sets
#        # and merging the two result sets above, we manually do these two steps here:
#        # a) capture the entire set of parent ayahs (which may be more then the desired pagination size), and
#        # b) sort them by the highest scores of their child matches
#        results.sort! { |a,b| b[:score] <=> a[:score] }
#        results = results[ ( page - 1 ) * size, size ]
#
#        render json: results
    end
end
