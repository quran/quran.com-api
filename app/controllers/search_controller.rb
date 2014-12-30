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
require 'elasticsearch'
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
                # TODO this is NOT how we're going to do thiاللَّهُ نُورُs
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
                index: [ 'trans*', 'text-font' ],
                body: {
                    indices_boost: indices_boost
                }
            } )
        end

        search_params.merge!( {
            type: 'data',

            explain: true, # debugging... on or off?
        } )

        # highlighting
        search_params[:body].merge!( {
            highlight: {
                fields: {
                    text: {
                        type: 'fvh',
                        matched_fields: [ 'text.root', 'text.stem_clean', 'text.lemma_clean', 'text.stemmed', 'text' ],
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


        } )

        # query
        search_params[:body].merge!( {
            query: {
                bool: {
                    must: [ {
                    ## NOTE leaving this in for future reference
                    #   terms: {
                    #        :'ayah.surah_id' => [ 24 ]
                    #        :'ayah.ayah_key' => [ '24_35' ]
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
        } )

        # other experimental stuff
        search_params[:body].merge!( {
            fields: [ 'ayah.ayah_key', 'ayah.ayah_num', 'ayah.surah_id', 'ayah.ayah_index', 'text' ],
            _source: [ "text", "ayah.*", "resource.*", "language.*" ],
        } )

        # aggregations
        search_params[:body].merge!( {
            aggs: {
                by_ayah_key: {
                    terms: {
                        field: "ayah.ayah_key",
                        size: 6236,
                        order: {
                            max_score: "desc"
                        }
                    },
                    aggs: {
                        max_score: {
                            max: {
                                script: "_score"
                            }
                        }
                    }
                }
            },
            size: 0
        } )

        #return search_params

        client = Elasticsearch::Client.new # trace: true, log: true;
        results = client.search( search_params )
        #return results

        total_hits = results[ 'hits' ][ 'total' ]
        buckets = results[ 'aggregations' ][ 'by_ayah_key' ][ 'buckets' ]
        imin = ( page - 1 ) * size
        imax = page * size - 1
        buckets_on_page = buckets[ imin .. imax ]
        keys = buckets_on_page.map { |h| h[ 'key' ] }
        doc_count = buckets_on_page.inject( 0 ) { |doc_count, h| doc_count + h[ 'doc_count' ] }

        #return buckets
        # restrict to keys on this page
        search_params[:body][:query][:bool][:must].unshift( {
            terms: {
                :'ayah.ayah_key' => keys
            }
        } )

        # limit to the number of docs we know we want
        search_params[:body][:size] = doc_count

        # get rid of the aggregations
        search_params[:body].delete( :aggs )

        #return search_params

        # pull the new query with hits
        results = client.search( search_params )
        #return results

        # override experimental
        search_params_text_font = {
            index: [ 'text-font' ],
            type: 'data',
            explain: false,
            size: keys.length,
            body: {
                query: {
                    ids: {
                        type: 'data',
                        values: keys.map { |k| "1_#{k}" }
                    }
                }
            }
        }
        results_text_font = client.search( search_params_text_font )
        ayah_key_to_font_text = results_text_font['hits']['hits'].map { |h| [ h['_source']['ayah']['ayah_key'], h['_source']['text'] ] }.to_h

        by_key = {}

        results[ 'hits' ][ 'hits' ].each do |hit|
            _source    = hit[ '_source' ]
            _score     = hit[ '_score' ]
            _highlight = ( hit.key?( 'highlight' ) && hit[ 'highlight' ].key?( 'text' ) ) ? hit[ 'highlight' ][ 'text' ].first : ''
            _ayah      = _source[ 'ayah' ]

            by_key[ _ayah[ 'ayah_key' ] ] = {
                  key: _ayah[ 'ayah_key' ],
                 ayah: _ayah[ 'ayah_num' ],
                surah: _ayah[ 'surah_id' ],
                index: _ayah[ 'ayah_index' ],
                score: 0,
                match: {
                    hits: 0,
                    best: []
                },
                bucket: {
                    surah: _ayah[ 'surah_id' ],
                    ayah:  _ayah[ 'ayah_num' ],
                    quran: {
                        text: nil
                    }
                }
            } if by_key[ _ayah[ 'ayah_key' ] ] == nil

            quran = by_key[ _ayah[ 'ayah_key' ] ][:bucket][:quran]

            if hit[ '_index' ] == 'text-font' && _highlight.length
                quran[:text] = _highlight
            elsif ayah_key_to_font_text[ _ayah[ 'ayah_key' ] ]
                quran[:text] = ayah_key_to_font_text[ _ayah[ 'ayah_key' ] ]
            end

            result = by_key[ _ayah[ 'ayah_key' ] ]

            if hit[ '_index' ] == 'text-font'
                while _source['text'].match( /([\d]+)-([a-z0-9]+)/ )
                    page = $1
                    code = $2
                    _source['text'].sub!( "#{page}-#{code}", "&#x#{code};" )
                end
            end

            result[:score]        = _score if _score > result[:score]
            result[:match][:hits] = result[:match][:hits] + 1
            result[:match][:best].push( {
                score:     _score,
                highlight: _highlight,
                source:    _source
            } )
        end

        by_key.keys.each do |key|
            quran = by_key[ key ][:bucket][:quran]
            while quran[:text].match( /([\d]+)-([a-z0-9]+)/ )
                quran[:page] = $1 if quran[:page] == nil
                code = $2
                quran[:text].sub!( "#{quran[:page]}-#{code}", "&#x#{code};" )
            end

        end

        return by_key.keys.sort { |a,b| by_key[ b ][ :score ] <=> by_key[ a ][ :score ] } .map { |k| by_key[ k ] }
    end

    def query
        render json: SearchController.query( params, request.headers, session )
        return
        # Init the config hash and the output
    end
end
