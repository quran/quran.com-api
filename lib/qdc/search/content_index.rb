module Qdc
  module Search
    #
    # This utility basically setup ES indexes for each language.
    #

    class ContentIndex
      LANG_INDEX_CLASSES = []
      TRANSLATION_LANGUAGES = Language.with_translations

      def self.get_index_name(language)
        "quran_#{language.iso_code}"
      end

      def self.remove_indexes
        TRANSLATION_LANGUAGES.each do |language|
          begin
            Verse.__elasticsearch__.delete_index! index: get_index_name(language)
          rescue Elasticsearch::Transport::Transport::Errors::NotFound => e
          end
        end
      end

      def self.import_all(content_type: Translation, language: nil)
        setup_language_index_classes(content_type)

        if language
          import_translation_for_language(language)
        else
          TRANSLATION_LANGUAGES.each do |lang|
            import_translation_for_language lang
          end
        end
      end

      def self.import_translation_for_language(language)
        puts "importing #{language.name} translations"

        LANG_INDEX_CLASSES[language.id].import(
          batch_size: 500,
          force: true,
          refresh: false,
          scope: 'translations',
          index: self.get_index_name(language)
        )
      end

      def self.setup_indexes
        TRANSLATION_LANGUAGES.each do |language|
          LANG_INDEX_CLASSES[language.id].__elasticsearch__.create_index!(index: self.get_index_name(language))
        end
      end

      def self.setup_language_index_classes(content_type = Translation)
        index_settings = YAML.safe_load(
          File.read('config/elasticsearch/settings.yml')
        )

        TRANSLATION_LANGUAGES.each do |language|
          lang_index_name = self.get_index_name(language)

          LANG_INDEX_CLASSES[language.id] = Class.new(content_type) do
            include Elasticsearch::Model

            scope :translations, -> {
              joins(:resource_content).where(language_id: language.id, resource_contents: { approved: true })
            }

            settings index_settings

            es_analyzer = language.es_analyzer_default.presence || 'english'
            index_name lang_index_name

            mappings dynamic: false do
              indexes :language_id, type: 'keyword'
              indexes :resource_id, type: 'keyword'
              indexes :chapter_id, type: 'keyword'

              indexes :text,
                      type: 'text',
                      similarity: 'my_bm25',
                      term_vector: 'with_positions_offsets',
                      analyzer: es_analyzer,
                      search_analyzer: es_analyzer do
                indexes :stemmed,
                        type: 'text',
                        similarity: 'my_bm25',
                        term_vector: 'with_positions_offsets_payloads',
                        analyzer: es_analyzer,
                        search_analyzer: 'shingle_analyzer'

                indexes :autocomplete,
                        type: 'search_as_you_type',
                        analyzer: es_analyzer
              end
            end

            def as_indexed_json(options = {})
              {
                language_id: language_id,
                text: clean_text_for_es,
                resource_id: resource_content_id,
                resource_name: resource_name,
                language_name: language_name,
                verse_id: verse_id,
                verse_key: verse_key,
                chapter_id: chapter_id,
                result_type: 'translation'
              }
            end
          end
        end
      end
    end
  end
end
