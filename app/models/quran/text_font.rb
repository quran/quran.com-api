# == Schema Information
#
# Table name: quran.text_font
#
#  id        :text             primary key
#  ayah_key  :text
#  surah_id  :integer
#  ayah_num  :integer
#  is_hidden :boolean
#  text      :text
#
class Quran::TextFont < ActiveRecord::Base
  extend Quran
  # extend Batchelor

  self.table_name = 'text_font'
  self.primary_key = 'id'

  belongs_to :ayah, class_name: 'Quran::Ayah', foreign_key: 'ayah_key'

  index_name 'text-font'

  settings YAML.load(
    File.read(
      File.expand_path(
        "#{Rails.root}/config/elasticsearch/settings.yml", __FILE__
      )
    )
  )

  mappings _all: { enabled: false } do
    indexes :text, type: 'multi_field' do
      indexes :text, type: 'string', similarity: 'my_bm25',
                     term_vector: 'with_positions_offsets_payloads'
      indexes :lemma, type: 'string', similarity: 'my_bm25',
                      term_vector: 'with_positions_offsets_payloads',
                      analyzer: 'quran_font_to_token_to_lemma'
      indexes :stem, type: 'string', similarity: 'my_bm25',
                     term_vector: 'with_positions_offsets_payloads',
                     analyzer: 'quran_font_to_token_to_stem'
      indexes :root, type: 'string', similarity: 'my_bm25',
                     term_vector: 'with_positions_offsets_payloads',
                     analyzer: 'quran_font_to_token_to_root'
      indexes :lemma_clean, type: 'string', similarity: 'my_bm25',
                            term_vector: 'with_positions_offsets_payloads',
                            analyzer: 'quran_font_to_token_to_lemma_normalized'
      indexes :stem_clean, type: 'string', similarity: 'my_bm25',
                           term_vector: 'with_positions_offsets_payloads',
                           analyzer: 'quran_font_to_token_to_stem_normalized'
      indexes :stemmed, type: 'string', similarity: 'my_bm25',
                        term_vector: 'with_positions_offsets_payloads',
                        analyzer: 'quran_font_to_token_to_arabic_stemmed'
      indexes :ngram, type: 'string', similarity: 'my_bm25',
                      term_vector: 'with_positions_offsets_payloads',
                      search_analyzer: 'quran_font_to_token',
                      index_analyzer: 'quran_font_to_token_to_arabic_ngram'
    end
  end

  def as_indexed_json(options = {})
    as_json.merge(resource: Content::Resource.find(1).as_json(include: :language))
  end

  def self.import(options = {})
    transform = lambda do |model|
      {
        index: {
          _id: "1_#{model.ayah_key.gsub!(/:/, '_')}",
          data: model.__elasticsearch__.as_indexed_json
        }
      }
    end

    options = { transform: transform, batch_size: 6236 }.merge(options)

    importing(options)
  end
end
