# This class is an endpoint for serving ayah suggestions from search text
class SuggestController < ApplicationController
  def query

    lang = params[:l] || params[:lang] || 'en' # TODO we need to explicitly pass in lang, this default shouldn't be around forever
    query = params[:q] || params[:query]
    size = ( params[:s] || params[:size] || '5' ).to_i

    # clean the query text
    query = Search::Query::Query.new( query )
    qtext = query[:query]


    if qtext.length < 3
      return render json: {error: 'not enough characters'}, status: 400
    end

    if Rails.env.production?
      client = Elasticsearch::Client.new host: ENV['ELASTICSEARCH_PORT_9200_TCP_ADDR']
    else
      client = Elasticsearch::Client.new  # trace: true, log: true;
    end

    indices = []
    querydsl = {}

    if query.is_arabic?
      indices.push( 'text' ) # "text" is just 6236 records of ayah text without tashkeel (mostly)
      querydsl = {
        match_phrase_prefix: {
          "text.autocomplete" => qtext
        }
      }
    else
      if lang == 'en' # TODO BUG this is a workaround for a bug, the translation-en index doesn't populate and for some reason populates 'translation' instead
        indices.push( 'translation' )
      end
      indices.push( "translation-#{lang}" )
      querydsl = {
        match: {
          "text.autocomplete" => {
            query: qtext,
            operator: "and"
          }
        }
      }
    end

    # TODO wrap this in try catch
    result = client.search(
      size: 30,
      _source_include: [ 'resource_id', 'ayah.surah_id', 'ayah.ayah_num', 'text' ],
      index: indices,
      body: {
        query: querydsl,
        highlight: {
          fields: {
            "text.autocomplete" => {
              number_of_fragments: 0, # just highlight the entire string instead of breaking it down into sentence fragments, that's easier for now
              pre_tags: [ "<b>" ],
              post_tags: [ "</b>" ],
              type: "postings"
            }
          }
        }
      }
    )

    processed = []
    seen = {}

    result['hits']['hits'].each do |hit|
      text = hit['highlight']['text.autocomplete'][0]
      ayah = "#{hit['_source']['ayah']['surah_id']}:#{hit['_source']['ayah']['ayah_num']}"
      if not seen.key?(ayah)
        seen[ayah] = true
        h = {
          #took: result['took'],
          #resource: hit['_source']['resource_id'],
          text: text,
          #full: hit['_source']['text'],
          #hlit: hit['highlight']['text.autocomplete'],
          ayah: ayah
        }
        processed.push( h )
      end
    end

    # renders top 5 by default
    render json: processed[0, size]
  end



end
