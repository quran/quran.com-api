module QuranNavigationSearchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    index_name 'chapters'
    settings YAML.load(
        File.read("config/elasticsearch/settings.yml")
    )

    def index_variation(document, options)
      request = {
          index: self.class.index_name,
          body: document
      }
      request.merge!(type: self.class.document_type) if self.class.document_type

      __elasticsearch__.client.index(request.merge!(options))
    end

    def es_mappings
      if self.is_a?(Chapter)
        names = [name_arabic, name_complex, name_simple]

        (names + translated_names.pluck(:name)).flatten.uniq.map do |name|
          {
              name: name,
              url: "/#{id}",
              verse_id: verses.first.id
          }
        end.flatten
      else
        # Juz
        verse_mapping.map do |chapter_id, verse_range|
          [
              {
                name: "Juz - #{juz_number} - #{Chapter.find(chapter_id).name_simple}",
                url: "/#{verse_range}",
                verse_id: ''
              },

              {
                name: "-  جز#{juz_number} - #{Chapter.find(chapter_id).name_arabic}",
                url: "/#{verse_range}",
                verse_id: ''
              },
          ]
        end.flatten
      end
    end

    def as_indexed_json(options = {})
      all_varriations = es_mappings
      first = all_varriations.first

      all_varriations[1..all_varriations.length].each do |variation|
        index_variation(variation, {}) if variation.presence
      end

      first
    end

    mappings dynamic: 'false' do
      indexes :name,
              type: 'text',
              term_vector: 'with_positions_offsets'

      indexes :url,
              type: 'text'
    end
  end
end
