# == Schema Information
#
# Table name: tafsir_ayah
#
#  tafsir_id :integer          not null
#  ayah_key  :text             not null
#

class Content::TafsirAyah < ActiveRecord::Base

  self.table_name = 'tafsir_ayah'

  belongs_to :tafsir, class_name: 'Content::Tafsir'
  belongs_to :ayah,   class_name: 'Quran::Ayah', foreign_key: 'ayah_key'

 # index_name 'tafsir' # NOTE we're overriding the index name from tafsir_ayah to tafsir

=begin
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
      indexes :stemmed, type: 'string', similarity: 'my_bm25',
                        term_vector: 'with_positions_offsets_payloads',
                        search_analyzer: 'arabic_normalized',
                        analyzer: 'arabic_ngram'
    end
  end
=end

  def as_indexed_json(options = {})
    resource = tafsir.resource

    as_json().merge(resource: resource.as_json(include: :language)).merge(text: tafsir.text)
  end

  def self.import(options = {})
    transform = lambda do |model|
      {
        index: {
          _id: "#{model.tafsir.resource_id}_#{model.ayah_key.gsub!(/:/, '_')}",
          data: model.__elasticsearch__.as_indexed_json
        }
      }
    end

    options = { transform: transform, batch_size: 6236 }.merge(options)

    importing(options)
  end
end

# notes:
# - a simple bridge table connecting to ayahs
#   since one tafsir can pertain to an entire contingent range of ayat, not just a single ayah
# - this class is used instead of the Content::Tafsir class for importing into the elasticsearch 'tafsir' type
