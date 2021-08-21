# frozen_string_literal: true

module QuranNavigationSearchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    index_name "navigation"
    settings YAML.safe_load(
      File.read('config/elasticsearch/settings.yml')
    )

    mappings dynamic: 'false' do
      indexes :text,
              type: 'text',
              index_options: 'offsets',
              index_phrases: true,
              similarity: 'my_bm25',
              analyzer: 'english'

      indexes :id,
              type: 'integer'

      indexes :result_type,
              type: 'text'

      indexes :key,
              type: 'text'
    end

    def self.bulk_import_with_variation
      documents = self.bulk_es_documents_with_variation
      errors = 0
      documents.in_groups(5).each do |data|
        response = __elasticsearch__.client.bulk(
          index: self.index_name,
          body: data.compact
        )

        if response['errors']
          errors += response['items'].select { |k, v| k.ids.first['error'] }.size
        end
      end

      puts "=====Done importing #{self.name.pluralize}==== Error count: #{errors}"
    end

    def self.bulk_es_documents_with_variation
      documents = all.map do |model|
        model.es_document_variations
      end.flatten

      documents.map do |document|
        {
          index: {
            data: document
          }
        }
      end
    end
  end

  def es_document_variations
    if self.is_a?(Chapter)
      chapter_document_variants
    elsif self.is_a?(Juz)
      juz_document_variants
    elsif self.is_a?(MushafPage)
      page_document_variants
    elsif self.is_a?(VerseKey)
      verse_document_variants
    end
  end

  protected

  def index_variation(document)
    params = {
      index: self.class.index_name,
      body: document
    }
    params[:type] = self.class.name

    __elasticsearch__.client.index(params)
  end

  def chapter_document_variants
    names = [
      name_arabic,
      name_complex,
      name_simple,
      "Surat #{name_simple}",
      "Surah #{name_simple}",
      "Surah #{id}",
      "Sura #{id}",
      "Surat #{id}",
      id.to_roman,
      "Chapter #{id}",
      "Ch #{id}",
      "#{id.ordinalize} surah"
    ]

    document_name = "Surah #{name_simple}"
    (names + translated_names.pluck(:name)).flatten.map do |name|
      {
        text: name,
        id: id,
        key: id,
        name: document_name,
        result_type: 'surah'
      }
    end
  end

  def juz_document_variants
    [
      {
        text: "Juz #{juz_number}",
        key: juz_number,
        id: juz_number,
        name: "Juz #{juz_number}",
        result_type: 'juz'
      },
      {
        text: "الجزء #{juz_number}",
        key: juz_number,
        id: juz_number,
        name: "Juz #{juz_number}",
        result_type: 'juz'
      },
      {
        text: juz_number,
        key: juz_number,
        id: juz_number,
        name: "Juz #{juz_number}",
        result_type: 'juz'
      }
    ]
  end

  def verse_document_variants
    [{
       text: verse_key,
       key: verse_key,
       id: id,
       name: "Surah #{chapter.name_simple}, verse #{verse_number}",
       result_type: 'ayah'
     },
     {
       text: verse_key.gsub(':', '/'),
       key: verse_key,
       id: id,
       name: "Surah #{chapter.name_simple}, verse #{verse_number}",
       result_type: 'ayah'
     }
    ]
  end

  def page_document_variants
    [
      {
        text: "Page #{page_number}",
        id: id,
        key: id,
        name: "Page #{page_number}",
        result_type: 'page'
      },
      {
        text: "Pg #{page_number}",
        id: id,
        key: id,
        name: "Page #{page_number}",
        result_type: 'page'
      },
      {
        text: "p #{page_number}",
        id: id,
        key: id,
        name: "Page #{page_number}",
        result_type: 'page'
      },
      {
        text: "#{page_number}",
        id: id,
        key: id,
        name: "Page #{page_number}",
        result_type: 'page'
      }
    ]
  end
end
