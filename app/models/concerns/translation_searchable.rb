require 'elasticsearch/model'

module TranslationSearchable
  extend ActiveSupport::Concern
  ES_TEXT_SANITIZER = Rails::Html::WhiteListSanitizer.new
=begin

  included do
    include Elasticsearch::Model
    index_name 'translations'

    settings YAML.load(
        File.read("config/elasticsearch/settings.yml")
    )

    def verse_path
      "#{verse.chapter_id}/#{verse.verse_number}"
    end

    def language_code
      language.iso_code
    end

    def as_indexed_json(options = {})
      hash = self.as_json(
          only: [:id, :resource_name, :verse_id],
          methods: [:verse_path, :language_code]
      )

      hash[:resource_id] = resource_content_id
      hash[:text] = ES_TEXT_SANITIZER.sanitize(text.to_s.strip, tags: %w(), attributes: [])

      hash
    end

    mappings dynamic: 'false' do
      indexes :verse_id, type: 'integer'
      indexes :verse_path, type: 'text'
      indexes :language_code, type: 'keyword'

      available_languages = Language.where(id: Translation.select('DISTINCT(language_id)').map(&:language_id).uniq)

      available_languages.each do |language|
        es_analyzer = language.es_analyzer_default.presence

        indexes :text,
                type: 'text',
                similarity: 'my_bm25',
                term_vector: 'with_positions_offsets',
                analyzer: es_analyzer || 'standard'

        indexes :stemmed,
                type: 'text',
                similarity: 'my_bm25',
                term_vector: 'with_positions_offsets_payloads',
                analyzer: es_analyzer || 'english'
      end
    end
  end
=end
end
