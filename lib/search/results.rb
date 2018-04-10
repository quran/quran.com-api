# frozen_string_literal: true

module Search
  class Results
    def initialize(search)
      @search = search
      @search_result = search.results.results
    end

    def results
      @search_result.map do |res|
        prepare_result res
      end
    end

    def total_count
      @search.response['hits']['total']
    end

    def current_page
      @search.current_page
    end

    def total_pages
      @search.total_pages
    end

    def per_page
      @search.limit_value
    end

    def took
      @search.took
    end

    protected
    def prepare_result(result)
      verse = Verse.find(result['_source']['id'])
      translations = []
      matched_words = {}
      words = result['inner_hits'].delete('words')

      words['hits']['hits'].map do |hit|
        word_id = hit['_source']['id']
        matched_words[word_id] = word_hightlight_class(hit)
      end

      result['inner_hits'].each_pair do |key, val|
        if val['hits']['total'] > 0
          val['hits']['hits'].each do |trans|
            translations << prepare_translation(trans, key)
          end
        end
      end

      { id: verse.id, verse_number: verse.verse_number, chapter_id: verse.chapter_id, verse_key: verse.verse_key, text_madani: verse.text_madani, words: prepare_words(verse, matched_words), translations: translations }
    end

    def prepare_translation(trans, key)
      author = trans['_source']['author']
      text = trans['highlight']["#{key}.text"].first

      { resource_name: author, text: text, id: trans['_source']['id'], language_name: trans['_source']['language_name'], resource_id: trans['_source']['resource_content_id'] }
    end

    def word_hightlight_class(hit)
      return 'hlt1' unless hit['highlight']

      highlight = hit['highlight'].values.first.first

      if matched = highlight.match(/(hlt\ds*)/)
        matched[0]
      else
        ''
      end
    end

    def prepare_words(verse, matched)
      words = verse.words.preload(:audio)

      words.map do |w|
        serializer = V3::WordSerializer.new(w, scope: {})
        serializer.as_json.merge(highlight: matched[w.id])
      end
    end
  end
end
