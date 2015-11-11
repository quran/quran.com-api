# == Schema Information
#
# Table name: content.transliteration
#
#  resource_id :integer          not null, primary key
#  ayah_key    :text             not null, primary key
#  text        :text             not null
#

# vim: ts=4 sw=4 expandtab
class Content::Transliteration < ActiveRecord::Base
  extend Content
  extend Batchelor

  self.table_name = 'transliteration'
  self.primary_keys = :resource_id, :ayah_key

  belongs_to :resource, class_name: 'Content::Resource'
  belongs_to :ayah,     class_name: 'Quran::Ayah', foreign_key: 'ayah_key'

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
                     term_vector: 'with_positions_offsets_payloads',
                     analyzer: 'standard'
      indexes :stemmed, type: 'string', similarity: 'my_bm25',
                        term_vector: 'with_positions_offsets_payloads',
                        analyzer: 'standard'
      indexes :phonetic, type: 'string', similarity: 'my_bm25',
                         term_vector: 'with_positions_offsets_payloads',
                         analyzer: 'dbl_metaphone'
    end
  end

  def as_indexed_json(options = {})
    as_json(include: { resource: { include: :language } })
  end

  def self.import(options = {})
    transform = lambda do |model|
      {
        index: {
          _id: "#{model.resource_id}_#{model.ayah_key.gsub!(/:/, '_')}",
          data: model.__elasticsearch__.as_indexed_json
        }
      }
    end

    options = { transform: transform, batch_size: 6236 }.merge(options)

    importing(options)
  end
end
