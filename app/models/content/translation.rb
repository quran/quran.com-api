# == Schema Information
#
# Table name: content.translation
#
#  resource_id :integer          not null, primary key
#  ayah_key    :text             not null, primary key
#  text        :text             not null
#

# vim: ts=4 sw=4 expandtab
class Content::Translation < ActiveRecord::Base
  extend Content
  # # extend Batchelor

  self.table_name = 'translation'
  self.primary_keys = :ayah_key, :resource_id # composite primary key which is a combination of ayah_key & resource_id

  # relationships
  belongs_to :resource, class_name: 'Content::Resource'
  belongs_to :ayah,     class_name: 'Quran::Ayah', foreign_key: 'ayah_key'

  scope :ordered,     ->              { joins( 'join quran.ayah on translation.ayah_key = ayah.ayah_key' ).order( 'translation.resource_id asc, ayah.surah_id asc, ayah.ayah_num asc' ) }
  scope :resource_id, ->(id_resource) { ordered.where( resource_id: id_resource ) }

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
                        analyzer: 'english'
      indexes :shingles, type: 'string', similarity: 'my_bm25',
                         term_vector: 'with_positions_offsets_payloads',
                         analyzer: 'shingle_analyzer'
    end
  end

  def as_indexed_json(options = {})
    as_json(include: { resource: { include: :language } })
  end

  def self.import(options = {})
    # TODO: Allow to import one specific language_code
    codes = options.delete(:language_codes) || []
    code = options.delete(:language_code) || nil

    codes << code unless code.nil?

    if codes.empty?
      language_codes_array = Content::Resource.select(:language_code).distinct.map { |row| row.language_code }
    else
      language_codes_array = Content::Resource.where(language: codes).select(:language_code ).distinct.map { |row| row.language_code }
    end

    Parallel.each(language_codes_array, in_processes: 16, progress: 'Importing translations') do |language_code|
      begin
        tries ||= 3

        query = lambda do
          joins(:resource).where(resource: {language_code: language_code})
        end

        transform = lambda do |model|
          {
            index: {
              _id: "#{model.resource_id}_#{model.ayah_key.gsub!(/:/, '_')}",
              data: model.__elasticsearch__.as_indexed_json
            }
          }
        end

        options = {
          index: "#{index_name}-#{language_code}",
          transform: transform,
          batch_size: 6236,
          query: query
        }.merge(options)

        importing(options)
      rescue Exception => e
        retry unless (tries -= 1).zero?
      ensure
        Rails.logger.ap e
      end
    end
  end
end
