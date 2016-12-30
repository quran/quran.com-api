# == Schema Information
#
# Table name: text
#
#  resource_id :integer          not null
#  ayah_key    :text             not null
#  text        :text             not null
#

# vim: ts=4 sw=4 expandtab
class Quran::Text < ActiveRecord::Base
  # extend Batchelor

  self.table_name = 'text'

  # relationships
  belongs_to :resource, class_name: 'Content::Resource'
  belongs_to :ayah,     class_name: 'Quran::Ayah', foreign_key: 'ayah_key'

  # scope
  default_scope { where resource_id: 6 } # limit to Simple Enhanced

  #settings YAML.load(
  #  File.read(
  #    File.expand_path(
  #      "#{Rails.root}/config/elasticsearch/settings.yml", __FILE__
  #    )
  #  )
  #)

=begin
  mappings _all: { enabled: false } do
    indexes :text, type: 'multi_field' do
      indexes :text,
        type: 'string',
        similarity: 'my_bm25',
        term_vector: 'with_positions_offsets_payloads',
        analyzer: 'arabic_normalized'
      indexes :stemmed,
        type: 'string',
        similarity: 'my_bm25',
        term_vector: 'with_positions_offsets_payloads',
        search_analyzer: 'arabic_normalized',
        analyzer: 'arabic_ngram'
      indexes :autocomplete,
        type: 'string',
        analyzer: 'autocomplete_arabic',
        search_analyzer: 'arabic_normalized',
        index_options: 'offsets'
    end
  end
=end

  def as_indexed_json(options = {})
    as_json(include: :resource)
  end

  def self.import( options = {} )
    transform = lambda do |a|
      this_data = a.__elasticsearch__.as_indexed_json
      ayah_data = a.ayah.__elasticsearch__.as_indexed_json

      {
        index: {
          _id:  "#{a.resource_id}_#{a.ayah_key.gsub!(/:/, '_')}",
          data: this_data.merge({
            ayah_key: ayah_data['ayah_key'].gsub!(/:/, '_'),
            text: ayah_data['text']
          })
        }
      }
    end

    options = { transform: transform, batch_size: 6236 }.merge(options)

    self.importing options
  end
end
