require 'elasticsearch/model'

module QuranSearchable
  TRANSLATION_LANGUAGES = Language.where(id: Translation.select('DISTINCT(language_id)').map(&:language_id).uniq)
  TRANSLATION_LANGUAGE_CODES = TRANSLATION_LANGUAGES.pluck(:iso_code) + ['default']
  VERSE_TEXTS_ATTRIBUTES = [:text_uthmani, :text_uthmani_simple, :text_imlaei, :text_imlaei_simple, :text_indopak, :text_indopak_simple]
  DEFAULT_TRANSLATIONS = [131, 149] # Translation we'll always search, regardless of language of queried text
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    ES_TEXT_SANITIZER = Rails::Html::WhiteListSanitizer.new

    settings YAML.load(
      File.read("config/elasticsearch/settings.yml")
    )

    alias_method :verse_id, :id

    def verse_path
      "#{chapter_id}/#{verse_number}"
    end

    def as_indexed_json(options = {})
      hash = self.as_json(
        only: [:id, :verse_key, :chapter_id],
        methods: [:verse_path, :verse_id]
      )

      # text_madani is Uthmani script
      # text_uthmani_simple is same without harq'at
      # text_imlaei is imlaei script
      # text_simple is imlaei without harq'at
      # We need to fix the naming in DB.
      #  - text_imlaei And text_imlaei_simple
      #  - text_uthmani And text_uthmani_simple

      hash[:text_uthmani] = text_madani
      hash[:text_uthmani_simple] = text_uthmani_simple

      hash[:text_imlaei] = text_imlaei
      hash[:text_imlaei_simple] = text_imlaei_change #text_imlaei.remove_dialectic

      hash[:text_indopak] = text_indopak
      hash[:text_indopak_simple] = text_indopak.remove_dialectic

      hash[:words] = words.where.not(text_madani: nil).map do |w|
        {
          id: w.id,
          madani: w.text_madani, # uthmani script
          simple: w.text_simple, # uthmani simple
          text_imlaei: w.text_imlaei
        }
      end

      translations.where.not(resource_content_id: DEFAULT_TRANSLATIONS).includes(:language).each do |trans|
        doc = {
          translation_id: trans.id,
          text: ES_TEXT_SANITIZER.sanitize(trans.text, tags: %w(), attributes: []),
          language: trans.language_name,
          resource_id: trans.resource_content_id,
          resource_name: trans.resource_name
        }

        hash["trans_#{trans.language.iso_code}"] ||= []
        hash["trans_#{trans.language.iso_code}"] << doc
      end

      translations.where(resource_content_id: DEFAULT_TRANSLATIONS).each do |trans|
        doc = {
          translation_id: trans.id,
          text: ES_TEXT_SANITIZER.sanitize(trans.text, tags: %w(), attributes: []),
          language: trans.language_name,
          resource_id: trans.resource_content_id,
          resource_name: trans.resource_name
        }

        hash["trans_default"] ||= []
        hash["trans_default"] << doc
      end

      hash
    end

    mappings dynamic: 'false' do
      indexes :verse_path, type: 'keyword' # allow user to search by path e.g 1/2, 2/29 etc
      indexes :chapter_id, type: 'integer' # Used for filters, when user want to search from specific surah
      indexes :verse_id, type: 'integer' # For loading record from db. We're not using ES's records method. All indexes will have this field
      indexes :verse_key, type: 'text' do
        indexes :keyword, type: 'keyword'
      end

      VERSE_TEXTS_ATTRIBUTES.each do |text_type|
        indexes text_type, type: "text" do
          indexes :text,
                  type: 'text',
                  similarity: 'my_bm25',
                  term_vector: 'with_positions_offsets_payloads',
                  analyzer: 'arabic_normalized',
                  search_analyzer: 'arabic_normalized'

          indexes :analyzed,
                  type: 'text',
                  term_vector: 'with_positions_offsets',
                  analyzer: 'arabic_synonym_normalized',
                  similarity: 'my_bm25',
                  search_analyzer: 'arabic_synonym_normalized'

          indexes :stemmed,
                  type: 'text',
                  similarity: 'my_bm25',
                  term_vector: 'with_positions_offsets',
                  search_analyzer: 'arabic_stemmed',
                  analyzer: 'arabic_ngram'

          #indexes :autocomplete,
          #        type: 'completion',
          #        analyzer: 'arabic_synonym_normalized',
          #        search_analyzer: 'arabic_synonym_normalized'
        end
      end

      indexes 'words', type: 'nested', include_in_parent: true, dynamic: false do
        indexes :madani,
                type: 'text',
                term_vector: 'with_positions_offsets',
                analyzer: 'arabic_synonym_normalized',
                similarity: 'my_bm25',
                search_analyzer: 'arabic_stemmed'

        indexes :text_imlaei,
                type: 'text',
                term_vector: 'with_positions_offsets',
                analyzer: 'arabic_synonym_normalized',
                similarity: 'my_bm25',
                search_analyzer: 'arabic_stemmed'

        indexes :simple,
                type: 'text',
                term_vector: 'with_positions_offsets',
                analyzer: 'arabic_synonym_normalized',
                similarity: 'my_bm25',
                search_analyzer: 'arabic_synonym_normalized'
      end

      TRANSLATION_LANGUAGES.each do |lang|
        es_analyzer = lang.es_analyzer_default.present? ? lang.es_analyzer_default : nil

        indexes "trans_#{lang.iso_code}", type: 'nested' do
          indexes :text, type: 'text' do
            indexes :text,
                    type: 'text',
                    similarity: 'my_bm25',
                    term_vector: 'with_positions_offsets',
                    analyzer: es_analyzer || 'standard',
                    search_analyzer: es_analyzer || 'standard'

            indexes :stemmed,
                    type: 'text',
                    similarity: 'my_bm25',
                    term_vector: 'with_positions_offsets_payloads',
                    analyzer: es_analyzer || 'english',
                    search_analyzer: 'shingle_analyzer'

            #indexes :autocomplete,
            #        type: 'completion',
            #        search_analyzer: 'standard',
            #        analyzer: es_analyzer || 'english'
          end
        end
      end

      indexes "trans_default", type: 'nested' do
        indexes :text, type: 'text' do
          indexes :text,
                  type: 'text',
                  similarity: 'my_bm25',
                  term_vector: 'with_positions_offsets',
                  analyzer: 'english',
                  search_analyzer: 'english'

          indexes :stemmed,
                  type: 'text',
                  similarity: 'my_bm25',
                  term_vector: 'with_positions_offsets_payloads',
                  analyzer: 'english',
                  search_analyzer: 'shingle_analyzer'
        end
      end
    end
  end
end
