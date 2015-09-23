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
require 'elasticsearch'

class SearchController < ApplicationController
    include LanguageDetection
    include SearchAyahKeys

    def query
      # Parameters to change the way search behaves

      # Fuzziness describes the distance from the actual word see: https://www.elastic.co/blog/found-fuzzy-search
      @fuzziness = 1
      @prefix_length = 1

      # Init
      if Rails.env.production?
        @client = Elasticsearch::Client.new host: ENV['ELASTICSEARCH_PORT_9200_TCP_ADDR']
      else
        @client = Elasticsearch::Client.new  # trace: true, log: true;
      end


      @page = page = [(params[:page] || params[:p] || 1 ).to_i, 1].max
      @size = size = [[(params[:size] || params[:s] || 20).to_i, 20].max, 40].min # sets the max to 40 and min to 20

      # Determining query language
      # - Determine if Arabic (regex); if not, determine boost using the following...
      #   a. Use Accept-Language HTTP header
      #   b. Use country-code to language mapping (determine country code from geolocation)
      #   c. Use language-code from user application settings (should get at least double priority to anything else)
      #   d. Fallback to boosting English if nothing was determined from above and the query is pure ascii

      @start_time = Time.now

      ayah_keys_results = self.fetch_ayah_keys()

      # return render json: ayah_keys_results

      total_hits = ayah_keys_results['hits']['total']
      bucket_ayah_keys = ayah_keys_results['aggregations']['by_ayah_key']['buckets']


      imin = (page - 1) * size
      imax = page * size - 1
      ayah_keys_on_current_page = bucket_ayah_keys[imin .. imax]

      keys = ayah_keys_on_current_page.map {|ayah_bucket| ayah_bucket['key'] }

      doc_count = ayah_keys_on_current_page.inject(0) {|doc_count, ayah_bucket| doc_count + ayah_bucket[ 'doc_count' ] }


      # restrict to keys on this page
      if @search_params[:body][:query][:bool][:must].present?
        @search_params[:body][:query][:bool][:must].unshift({
          terms: {
            :'ayah.ayah_key' => keys
          }
        })
      else
        # TODO: See if this must be :should and not :must
        @search_params[:body][:query][:bool][:must] = [{
          terms: {
            :'ayah.ayah_key' => keys
          }
        }]
      end

      # limit to the number of docs we know we want
      @search_params[:body][:size] = doc_count

      # get rid of the aggregations
      @search_params[:body].delete(:aggs)

      # pull the new query with hits
      results = @client.search(@search_params).deep_symbolize_keys

      by_key = {}

      results[:hits][:hits].each do |hit|
          _source    = hit[:_source]
          _score     = hit[:_score]
          _text = ( hit.key?( :highlight ) && hit[ :highlight ].key?( :text ) && hit[ :highlight ][ :text ].first.length ) ? hit[ :highlight ][ :text ].first : _source[ :text ]
          _ayah      = _source[:ayah]

          by_key[_ayah[:ayah_key]] = {
                key: _ayah[:ayah_key],
               ayah: _ayah[:ayah_num],
              surah: _ayah[:surah_id],
              index: _ayah[:ayah_index],
              score: 0,
              match: {
                  hits: 0,
                  best: []
              }
          } if by_key[ _ayah[:ayah_key] ] == nil

          #quran = by_key[ _ayah[ 'ayah_key' ] ][:bucket][:quran]
          result = by_key[ _ayah[:ayah_key] ]

          # TODO: transliteration does not have a resource or language.
          #id name slug text lang dir
          extension = {
              text: _text,
              score: _score,
          }.merge( _source[:resource] ? {
              id: _source[:resource][:resource_id],
              name: _source[:resource][:name],
              slug: _source[:resource][:slug],
              lang: _source[:resource][:language_code],
          } : {name: 'Transliteration'} )
          .merge( _source[:language] ? {
              dir: _source[:language][:direction],
          } : {} )
#            .merge( { debug: hit } )

          if hit[:_index] == 'text-font' && _text.length
              extension[:_do_interpolate] = true
          end

          result[:score]        = _score if _score > result[:score]
          result[:match][:hits] = result[:match][:hits] + 1
          result[:match][:best].push( {}.merge!( extension ) ) # if result[:match][:best].length < 3
      end

      word_id_hash = {}
      word_id_to_highlight = {}

      # attribute the "bucket" structure for each ayah result
      # return render json: by_key.values
      by_key.values.each do |result|

          result.merge!(Quran::Ayah.get_ayat( { surah_id: result[:surah], ayah: result[:ayah], content: params[:content], audio: params[:audio] } ).first.as_json.deep_symbolize_keys)
          if result[:content]
              resource_id_to_bucket_content_index = {}
              result[:content].each_with_index do | c, i |
                  resource_id_to_bucket_content_index[ c[:id].to_i ] = i
              end

              #
              result[:match][:best].each do |b|
                  id = b[:id].to_i

                  if index = resource_id_to_bucket_content_index[ id ]
                      result[:content][ index ][:text] = b[:text]
                  end
              end
          end

          result[:match][:best].each do |h|
              if h.delete( :_do_interpolate )
                  t = h[:text].split( '' )
                  parsed = { word_ids: [] }
                  for i in 0 .. t.length - 1
                      # state logic
                      # if its in a highlight tag
                          # if its in the class value
                      # if its in a word id
                          # if its a start index
                          # if its an end index
                      # if its highlighted
                      parsed[:a_number] = t[i].match( /\d/ ) ? true : false
                      parsed[:a_start_index] = false
                      parsed[:an_end_index] = false

                      if not parsed[:in_highlight_tag] and t[i] == '<'
                          parsed[:in_highlight_tag] = true
                      elsif parsed[:in_highlight_tag] and t[i] == '<'
                          parsed[:in_highlight_tag] = false
                      end

                      if parsed[:in_highlight_tag] and not parsed[:in_class_value] and t[i-1] == '"' and t[i-2] == '='
                          parsed[:in_class_value] = true
                      elsif parsed[:in_highlight_tag] and parsed[:in_class_value] and t[i] == '"'
                          parsed[:in_class_value] = false
                      end

                      if parsed[:a_number] and ( i == 0 or ( t[i-1] == ' ' or t[i-1] == '>' ) )
                          parsed[:in_word_id] = true
                          parsed[:a_start_index] = true
                      elsif not parsed[:a_number] and parsed[:in_word_id]
                          parsed[:in_word_id] = false
                      end

                      if parsed[:in_word_id] and ( i == t.length - 1 or ( t[i+1] == ' ' or t[i+1] == '<' ) )
                          parsed[:an_end_index] = true
                      end

                      # control logic
                      if i == 0
                          parsed[:current] = { word_id: [], indices: [], highlight: [] }
                      end


                      if parsed[:in_class_value]
                          parsed[:current][:highlight].push( t[i] )
                      end

                      if parsed[:in_word_id]

                          parsed[:current][:word_id].push( t[i] )

                          if parsed[:a_start_index]
                              parsed[:current][:indices][0] = i
                          end

                          if parsed[:an_end_index]
                              parsed[:current][:indices][1] = i
                              parsed[:current][:word_id] = parsed[:current][:word_id].join( '' )
                              parsed[:current][:highlight] = parsed[:current][:highlight].join( '' )
                              if not parsed[:current][:highlight].length > 0
                                  parsed[:current].delete( :highlight )
                              end

                              if parsed[:current].key?( :highlight )
                                  word_id_to_highlight[ parsed[:current][:word_id].to_i ] = parsed[:current][:highlight] #true
                              end

                              parsed[:word_ids].push( parsed[:current] )
                              parsed[:current] = { word_id: [], indices: [], highlight: [] }
                          end
                      end
                  end

                  if parsed[:word_ids].length > 0
                      # init the word_id_hash

                      result[:quran].each do |h|
                          word_id_hash[ h[:word][:id].to_s.to_sym ] = { text: h[:word][:arabic] } if h[:word][:id]
                          if word_id_to_highlight.key? h[:word][:id].to_i
                              h[:highlight] = word_id_to_highlight[ h[:word][:id] ]
                          end
                      end

                      parsed[:word_ids].each do |p|
                          word_id = p[:word_id] #.delete :word_id
                          word_id_hash[ word_id.to_s.to_sym ].merge!( p )
                      end
                  end

                  word_id_hash.each do |id,h|
                      for i in h[:indices][0]  .. h[:indices][1]
                          t[i] = nil
                      end
                      t[ h[:indices][0] ] = h[:text]
                  end
                  h[:text] = t.join( '' )
              end
          end
          result[:key].gsub! /_/, ':'
          result[:match][:best] = result[:match][:best][0 .. 2]
      end

      return_result = by_key.values.sort! { |x, y| y[:score] <=> x[:score] }

      delta_time = Time.now - @start_time

      render json: {
        query: params[:q],
        hits: return_result.length,
        page: page,
        size: size,
        took: delta_time,
        total: doc_count,
        results: return_result
        }
    end
end
