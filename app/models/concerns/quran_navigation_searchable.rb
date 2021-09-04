# frozen_string_literal: true

module QuranNavigationSearchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    has_many :navigation_search_records, as: :searchable_record

    index_name "navigation"
    settings YAML.safe_load(
      File.read('config/elasticsearch/settings.yml')
    )

    mappings dynamic: 'false' do
      indexes :text,
              type: 'text',
              index_options: 'offsets',
              index_phrases: true,
              #similarity: 'my_bm25',
              analyzer: 'english' do
        indexes :term,
                type: 'keyword'
      end

      indexes :id,
              type: 'integer'

      indexes :priority, type: 'integer'

      indexes :result_type,
              type: 'keyword'

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
          errors += response['items'].select { |k, v| k['status'] != 200 }.size
        end
      end

      puts "=====Done importing #{self.name.pluralize}==== Error count: #{errors}"
    end

    def self.bulk_es_documents_with_variation
      documents = all.map do |model|
        model.es_document_variations
      end.flatten

      index = 0
      documents.map do |document|
        index += 1

        {
          index: {
            _id: "#{document[:priority].to_s}-#{index}",
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
    short_name = name_simple.gsub(/Al|An|-|'/, '')
    simple = name_simple.gsub(/-|'/, ' ')

    names = [
      id.to_s,
      short_name,
      simple,
      name_arabic,
      name_complex,
      name_simple,
      "Surat #{name_simple}",
      "Surah #{name_simple}",
      "Sura #{name_simple}",

      "Surat #{id}",
      "Surah #{id}",
      "Sura #{id}",

      "Surat #{short_name}",
      "Surah #{short_name}",
      "Sura #{short_name}",

      id.to_roman,
      "Chapter #{id}",
      "Ch #{id}",
      "#{id.ordinalize} surah"
    ].uniq

    document_name = "Surah #{name_simple}"
    (names + translated_names.pluck(:name)).flatten.map do |name|
      {
        id: id,
        text: name,
        key: id,
        name: document_name,
        result_type: 'surah',
        priority: 1 + id # We're using priority for aggregrating uniq navigational hits
      }
    end
  end

  def juz_document_variants
    variants = [
      juz_number.to_s,
      "Juz #{juz_number}",
      "Para #{juz_number}",
    ]

    variants.map do |variant|
      {
        id: juz_number,
        text: variant,
        key: juz_number,
        name: "Juz #{juz_number}",
        result_type: 'juz',
        priority: 60000 + juz_number
      }
    end
  end

  def page_document_variants
    variants = [
      page_number.to_s,
      "Page #{page_number}",
      "Pg #{page_number}",
      "P #{page_number}",
      "p#{page_number}"
    ]

    variants.map do |variant|
      {
        id: page_number,
        text: variant,
        key: page_number,
        name: "Page #{page_number}",
        result_type: 'page',
        priority: 50000 + page_number
      }
    end
  end

  def verse_document_variants
    variants = [
      verse_key,
      "#{chapter_id.to_roman} #{verse_number}",
      "chapter #{chapter_id} verse #{verse_number}",
      "ch#{chapter_id} v#{verse_number}", #ch23 v2
      "ch#{chapter_id}v#{verse_number}", #ch23v2
      "c#{chapter_id}v#{verse_number}", #v2v3
      "#{chapter.name_arabic} #{verse_number}",
      "surah #{chapter_id} ayah #{verse_number}",
      "ayah #{verse_number} surah #{chapter_id}",
    ]

    variants.map do |variant|
      {
        id: id,
        text: variant,
        key: verse_key,
        name: "Surah #{chapter.name_simple}, verse #{verse_number}",
        result_type: 'ayah',
        priority: 100000 + id
      }
    end
  end
end
