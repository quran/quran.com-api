module SearchAyahKeys
  extend ActiveSupport::Concern

  included do
    attr_accessor :search_params, :most_fields_fields_val, :query
  end

  def fetch_ayah_keys
    @search_params = Hash.new
    #
    @most_fields_fields_val = Array.new

    if @query =~ /^(?:\s*[\p{Arabic}\p{Diacritic}\p{Punct}\p{Digit}]+\s*)+$/
      @search_params.merge!({
        index: ['text-font', 'tafsir'],
        body: {
          indices_boost: {
            :"text-font" => 4,
            :"tafsir"    => 1
          }
        }
      })
      @most_fields_fields_val = [
        'text^5',
        'text.lemma^4',
        'text.stem^3',
        'text.root^1.5',
        'text.lemma_clean^3',
        'text.stem_clean^2',
        'text.ngram^2',
        'text.stemmed^2'
      ]

    else
      @most_fields_fields_val = ['text^1.6', 'text.stemmed']

      # TODO filter for langs that have translations only
      @search_params.merge!( {
        index: ['trans*', 'text-font'],
        body: {
          indices_boost: @indices_boost #coming from language detection
        }
      })

      # Determine if this is an AND/OR query
      if @query.downcase.split('or').length > 1
        query_type = :or
        query_split = @query.downcase.split('or')
      else
        query_type = :and
      end
    end

    @search_params.merge!({
      type: 'data',

      explain: false, # debugging... on or off?
    })

    # highlighting
    @search_params[:body].merge!( {
      highlight: {
        fields: {
          text: {
            type: 'fvh',
            matched_fields: ['text.root', 'text.stem_clean', 'text.lemma_clean', 'text.stemmed', 'text'],
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
    })

    # query
    bool = {}
    if query_type == :or
      bool[:should] = query_split.map do |q|
        {
          multi_match: {
            type: 'most_fields',
            query: q.strip,
            fuzziness: @fuzziness,
            prefix_length: @prefix_length,
            fields: @most_fields_fields_val,
            minimum_should_match: '3<62%'
          }
        }
      end
    else
      bool[:must] = [{
        ## NOTE leaving this in for future reference
        #   terms: {
        #        :'ayah.surah_id' => [ 24 ]
        #        :'ayah.ayah_key' => [ '24_35' ]
        #    }
        #}, {
        multi_match: {
          type: 'most_fields',
          query: @query,
          fuzziness: @fuzziness,
          prefix_length: @prefix_length,
          fields: @most_fields_fields_val,
          minimum_should_match: '3<62%'
        }
      }]
    end

    @search_params[:body].merge!( {
      query: {
        bool: bool
      },
    })

    # other experimental stuff
    @search_params[:body].merge!( {
      fields: [ 'ayah.ayah_key', 'ayah.ayah_num', 'ayah.surah_id', 'ayah.ayah_index', 'text' ],
      _source: [ "text", "ayah.*", "resource.*", "language.*" ],
    })

    # Aggregate and bucket results based off of Ayah Key. This is neccessary
    # as the results can come from an ayah's associated translations.
    @search_params[:body].merge!( {
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
    })

    return @client.search(@search_params)
  end
end
