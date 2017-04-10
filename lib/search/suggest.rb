module Search
  class Suggest
    attr_accessor :query, :lang, :size

    def initialize(query, lang: 'en', size: 30)
      @query = Search::Query.new(query)
      @lang = lang
      @size = size
    end

    def get_suggestions
      q = search_params
      process_results Verse.search(q).results.results
    end

    def translation_path
      "trans_#{lang}"
    end

    def translation_text_field_name
      "#{translation_path}.text"
    end

    def search_params
      {
        size: @size,
        query: query_dict,
        highlight: highlight
      }
    end

    def query_dict
      if @query.is_arabic?
        base_query = {
          match_phrase_prefix: {
            translation_text_field_name => @query.query,
          }
        }
      else
        base_query = {
          match_phrase: {
            translation_text_field_name => {
              query: @query.query,
              operator: 'and'
            }
          }
        }
      end

      {
        nested: {
          path: translation_path,
          query: base_query
        }
      }
    end

    def highlight
      {
        fields: {
          translation_text_field_name => {
            number_of_fragments: 0, # just highlight the entire string instead of breaking it down into sentence fragments, that's easier for now
            pre_tags: [ '<b>' ],
            post_tags: [ '</b>' ],
            type: 'plain'
          }
        }
      }
    end

    def process_results(es_response)
      processed = []
      seen = {}

      es_response.each do |hit|
        if hit.key?('highlight')
          text = hit['highlight'][translation_text_field_name][0]
        else
          text = hit['_source'][translation_path][0].text
        end
        ayah = "#{hit['_source']['verse_key']}"
        href = "/#{hit['_source']['verse_key'].gsub(/:/,'/')}"

        unless seen.key?(ayah)
          seen[ayah] = true
          item = {
            text: text,
            href: href,
            ayah: ayah
          }
          processed.push( item )
        end
      end

      processed[0, @size]
    end
  end
end