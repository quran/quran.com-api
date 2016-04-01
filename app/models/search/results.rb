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
      ayahs = Quran::Ayah.get_ayahs_by_array(keys)

      quran_content = Content::Resource.bucket_quran(1, keys)

      results_buckets.map.with_index do |ayah_result, index|
        ayah = ayahs[index].attributes

        ayah[:quran] = quran_content[index]

        ayah.merge!(score: ayah_result['average_score']['value'], hits: ayah_result['match']['hits']['hits'].count)

        match = ayah_result['match']['hits']['hits'].map do |hit|
          hash = {
            score: hit['_score'],
            text: hit['highlight'] ? hit['highlight']['text'].first : hit['_source']['text']
          }

          hash.merge!(hit['_source']['resource'])
          # hash.merge!(hit['_source']['language'])

          # This is when it's a word font that's a hit, aka text-font index
          if hash['cardinality_type'] == '1_word'
            word_ids = hash[:text].scan(/(hlt[0-9]*)..(?!>)([0-9]*)(?=<)/)
            word_ids.each do |word_id_array|
              ayah[:quran].find{|ayah| ayah[:word][:id] == word_id_array.last.to_i}[:highlight] = word_id_array.first
            end

            hash[:text] = ayah['text']
            hash
          end

          hash
        end

        ayah.merge!(match: match)

        ayah
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
