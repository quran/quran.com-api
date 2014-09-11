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

    def self.search(query, page = 1, size = 20)

        # The query hash
        query_hash = {
            query: {
                bool: {
                    should: [
                        has_child: {
                            type: 'translation',
                            query: {
                                match: {
                                    text: {
                                        query: query,
                                        operator: 'or',
                                        minimum_should_match: '3<62%'
                                    }
                                }
                            }
                        },
                        has_child: {
                            type: 'transliteration',
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
                    ]
                }
                
            }
        }

        # Matched parent ayahs
        matched_parents = searching(query_hash).page(page).per(size)

        # # Array of ayah keys to use to search for the child model
        # array_of_ayah_keys = matched_parents.map{|r| r._source.ayah_key}
        
        # # Search child models
        # matched_children = ( OpenStruct.new Content::Translation.matched_children(query, array_of_ayah_keys) ).responses
        # # Rails.logger.ap matched_children
        
        # # Init results of matched parent and child array
        # results = Array.new


        # matched_parents.results.each_with_index do |ayah, index|
        #     # Rails.logger.info ayah.to_hash
        #     best = Array.new

        #     matched_children[index]["hits"]["hits"].each do |hit|
        #         best.push({
        #             name: hit["_source"]["resource"]["name"], 
        #             slug: hit["_source"]["resource"]["slug"], 
        #             type: hit["_source"]["resource"]["type"], 
        #             highlight: hit["highlight"]["text"].first, 
        #             score: hit["_score"],
        #             id: hit["_source"]["resource_id"],
        #             text: hit["_source"]["text"]
        #         })
        #     end


        #     ayah = {
        #         key: ayah._source.ayah_key,
        #         ayah: ayah._source.ayah_num,
        #         surah: ayah._source.surah_id,
        #         index: ayah._source.ayah_index,
        #         score: ayah._score,
        #         match: {
        #             hits: matched_children[index]["hits"]["total"],
        #             # testing: matched_children[index]["hits"]["hits"], #use this to test the output
        #             best: best

        #         },
        #         bucket: {
        #             surah: ayah._source.surah_id,
        #             quran: {
        #                 text: ayah._source.text
        #             },
        #             ayah: ayah._source.ayah_num

        #         }
        #     }
        #     results.push(ayah)
        # end

        # return results
    end

end
