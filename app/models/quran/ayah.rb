class Quran::Ayah < ActiveRecord::Base
    extend Quran

    self.table_name = 'ayah'
    self.primary_key = 'ayah_key'
    # Rails.logger.ap self.table_name
    belongs_to :surah, class_name: 'Quran::Surah'

    has_many :words, class_name: 'Quran::Word', foreign_key: 'ayah_key'

    has_many :tokens, class_name: 'Quran::Token', through: :words
    has_many :stems, class_name:  'Quran::Stem',  through: :words
    has_many :lemmas, class_name: 'Quran::Lemma', through: :words
    has_many :roots, class_name:  'Quran::Root',  through: :words

    has_many :_tafsir_ayah, class_name: 'Content::TafsirAyah', foreign_key: 'ayah_key'

    has_many :audio, class_name: 'Audio::File', foreign_key: 'ayah_key'
    has_many :texts, class_name: 'Quran::Text', foreign_key: 'ayah_key'
    has_many :images, class_name: 'Quran::Image', foreign_key: 'ayah_key'
    has_many :glyphs, class_name: 'Quran::WordFont', foreign_key: 'ayah_key'
    has_many :tafsirs, class_name: 'Content::Tafsir', through: :_tafsir_ayah
    has_many :translations, class_name: 'Content::Translation', foreign_key: 'ayah_key'
    has_many :transliterations, class_name: 'Content::Transliteration', foreign_key: 'ayah_key'

    # The relationships below were created as database-side views for use with elasticsearch
    has_many :text_roots,  class_name: 'Quran::TextRoot', foreign_key: 'ayah_key'
    has_many :text_lemmas, class_name: 'Quran::TextLemma', foreign_key: 'ayah_key'
    has_many :text_stems,  class_name: 'Quran::TextStem', foreign_key: 'ayah_key'
    has_many :text_tokens, class_name: 'Quran::TextToken', foreign_key: 'ayah_key'

    def self.fetch_ayahs(surah_id, from, to)
        self
        .where("quran.ayah.surah_id = ? AND quran.ayah.ayah_num >= ? AND quran.ayah.ayah_num <= ?", surah_id, from, to)
        .order("quran.ayah.surah_id, quran.ayah.ayah_num")
    end



    ############### ES FUNCTIONS ################################################################# 

    # This function affects the indexed JSON for
    # Quran::Ayah.import
    # def as_indexed_json(options={})
    #   self.as_json(
    #     include: {
    #         translations: {
    #             only: [:resource_id, :ayah_key, :text],
    #             # methods: [:resource_info]
    #             # include: {
    #             #     resource: {
    #             #         only: [:slug, :name, :type]
    #             #     }
    #             # }
    #         }

    #     })
    # end

    # Get all the mappings!
    # curl -XGET 'http://localhost:9200/_all/_mapping'
    # curl -XGET 'http://localhost:9200/_mapping'
    #
    # Example: https://gist.github.com/karmi/3200212
    mapping _source: { enabled: true }  do
      indexes :ayah_index, type: "integer"
      indexes :surah_id, type: "integer"
      indexes :ayah_num, type: "integer"
      indexes :page_num, type: "integer"
      indexes :juz_num, type: "integer"
      indexes :hizb_num, type: "integer"
      indexes :rub_num, type: "integer"
      indexes :text, type: "string"
      indexes :ayah_key, type: "string"

    end

    def self.search(query, page = 1, size = 20, types)
        types = types.map{|t| t.split(".").last}

        should_array = Array.new

        types.each do |type|
            should_array.push({
                has_child: {
                    type: type,
                    query: {
                        match: {
                            text: {
                                query: query,
                                operator: 'or',
                                minimum_should_match: '3<62%'
                            }
                        }
                    }
                }
            })
        end

        # The query hash
        query_hash = {
            query: {
                bool: {
                    should: should_array,
                    minimum_number_should_match: 1
                }
                
            }
        }

        # Matched parent ayahs
        matched_parents = searching(query_hash).page(page).per(size)

    end


    def self.matched_children (query, ayat = [] )
        msearch_body = []
        ayat.each do |ayah_key|
            ayah = {
                search: {
                    highlight: {
                        fields: {
                            text: {
                                type: 'fvh',
                                number_of_fragments: 1,
                                fragment_size: 1024
                            }
                        },
                        tags_schema: 'styled'
                    },
                    # fields: [:ayah_key],
                    explain: true,
                    # fielddata_fields: ["ayah_key"], # this will split each of the words into an array
                    query: {
                        bool: {
                            must: [ {
                                term: {
                                    _parent: {
                                        value: ayah_key
                                    }
                                }
                            }, {
                                match: {
                                    text: {
                                        query: query,
                                        operator: 'or',
                                        minimum_should_match: '3<62%'
                                    }
                                }
                            } ]
                        }
                    },
                    size: 3
                }
            }
            msearch_body.push(ayah)
        end

        msearch_query = {
            index: 'quran',
            type: [ 'text' ],
            body: msearch_body
        }
        self.__elasticsearch__.client.msearch( msearch_query )
    end

end
