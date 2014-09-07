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
    mapping  do
      indexes :ayah_index, type: 'integer'
      indexes :surah_id, type: 'integer'
      indexes :ayah_num, type: 'integer'
      indexes :page_num, type: 'integer'
      indexes :juz_num, type: 'integer'
      indexes :hizb_num, type: 'integer'
      indexes :rub_num, type: 'integer'
      indexes :text, type: 'string'
      indexes :ayah_key, type: 'string'

#      indexes :translations, type: :nested do
#        indexes :text
#        indexes :ayah_key
#      end

    end

    def self.searching
        # query = {
        #     query: {
        #         "filtered" => {
        #             query: {
        #                 match: {
        #                     "translations.text" => "Allah"
        #                 }
        #             },
        #             filter: {
        #                 term: {
        #                     "text" => "Allah"
        #                 }
        #             }

        #         }

        #     }
        # }
        #
         config_query = {
            bool:  {
                must:  [
                {
                    match:  {
                        text:  {
                            query:  "Allah",
                            operator:  'or',
                            minimum_should_match:  '3<62%'
                        }
                    }
                } ]
            }
        }


        matched_children = {
            query: {
                function_score: {
                    query: {
                        bool: {
                            must: [ {
                                term: {
                                    _parent: {
                                        value: "",
                                         boost: 0
                                    }
                                }
                            }, config_query ]
                        }
                    }

                }
            }
        }
        # self.search(matched_children)
        #
        # # match: {
                #     "translations.text" => {
                #         query: "Allah",
                #         type: "phrase"
                #     }
                # }
        query = {
            query: {
                has_child: {
                    type: 'translation',
                    query: {
                        match: {text: "armikut"}
                    }
                }
            }
        }

        self.search(query)

    end

end
