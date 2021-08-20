# frozen_string_literal: true

module QuranNavigationSearchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    index_name "quran_#{to_s.pluralize.underscore}"
    settings YAML.safe_load(
      File.read('config/elasticsearch/settings.yml')
    )

    mappings dynamic: 'false' do
      indexes :text,
              type: 'text',
              analyzer: 'english',
              index_options: 'offsets',
              index_phrases: true,
              similarity: 'my_bm25' do
        indexes :autocomplete,
                type: 'search_as_you_type'
      end

      # text name that is used for highlighting
      indexes :raw,
              type: 'text',
              index_phrases: true,
              similarity: 'my_bm25',
              term_vector: 'with_positions_offsets'

      indexes :id,
              type: 'integer'

      indexes :url,
              type: 'text'
    end
  end

  def as_indexed_json(_options = {})
    if is_a?(Chapter)
      {
        text: [name_simple.gsub(/[\W]/, ' '), name_complex, name_arabic, id] + translated_names.pluck(:name),
        raw: "Surah #{name_simple}",
        url: "/#{id}",
        id: id,
        verse_id: verses.first.id,
        type: 'chapter'
      }
    elsif is_a?(Juz)
      # Juz
      {
        text: ["Juz #{juz_number}", "الجزء#{juz_number}"],
        raw: "Juz #{juz_number}",
        url: "/juz/#{juz_number}",
        id: id,
        verse_id: '',
        type: 'juz'
      }
    else
      # Page
      {
        text: "Page #{page_number}",
        raw: "Page #{page_number}",
        url: "/page/#{page_number}",
        verse_id: '',
        id: id,
        type: 'page'
      }
    end
  end
end
