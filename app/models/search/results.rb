module Search
  class Results
    include Virtus.model

    attribute :options, Hash
    attribute :aggregations, Hash
    attribute :hits, Hash
    attribute :took, Integer
    attribute :time_out, Boolean
    attribute :_shards, Hash
    attribute :type, Symbol

    def initialize(results, type)
      results.each do |key, value|
        # So that we can access the methods quickly and easily.
        name = key.to_s.include?('.') ? key.split('.').last : key
        self.class.send(:attr_accessor, key)
        instance_variable_set("@#{name}", value)
      end

      @type = type
    end

    def total_size
      if self.aggregations?
        aggregations['by_ayah_key']['buckets'].count
      else
        hits['total']
      end
    end

    def total_length
      size
    end

    def results
      hits['hits']
    end

    def find_in_aggregations(ayah_key)
      aggregations['by_ayah_key']['buckets'].find{|bucket| bucket['key'] == ayah_key}
    end

    def aggregation_records
      results_buckets = aggregations['by_ayah_key']['buckets']
      keys = results_buckets.map{|ayah_result| ayah_result['key'].gsub('_', ':')}
      ayahs = Quran::Ayah
        .includes(glyphs: {word: [:corpus, :token]})
        .includes(:text_tashkeel)
        .by_array(keys)

      results_buckets.map.with_index do |ayah_result, index|
        ayah_result.merge!(ayah: ayahs[index].as_json)

        ayah_result.merge!(score: ayah_result['average_score']['value'], hits: ayah_result['match']['hits']['hits'].count)

        match = ayah_result['match']['hits']['hits'].map do |hit|
          hash = {
            score: hit['_score'],
            text: hit['highlight'] ? hit['highlight']['text'].first : hit['_source']['text']
          }

          hash.merge!(hit['_source']['resource'])

          # This is when it's a word font that's a hit, aka text-font index
          if hash['cardinality_type'] == '1_word'
            word_ids = hash[:text].scan(/(hlt\d*)..(?!>)([\d,\s]+).(?!<)/)
            word_ids.each do |word_id_array|
              ids = word_id_array.last.split(' ').each do |id|
                ayah_result[:ayah][:words].find{|word| word['word_id'] == id.to_i}[:highlight] = word_id_array.first
              end
            end
            nil
          else
            hash
          end
        end

        ayah_result.merge!(match: match.compact)

        ayah_result
      end
    end

    def aggregations?
      self.instance_variable_defined? :@aggregations
    end

    def records
      return self.aggregation_records if self.aggregations?
    end

    def keys
      aggregations['by_ayah_key']['buckets'].map { |bucket| bucket['key'] }
    end
  end
end
