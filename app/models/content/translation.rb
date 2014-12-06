# vim: ts=4 sw=4 expandtab
class Content::Translation < ActiveRecord::Base
    extend Content
    extend Batchelor

    self.table_name = 'translation'
    self.primary_keys = :ayah_key, :resource_id # composite primary key which is a combination of ayah_key & resource_id

    # relationships
    belongs_to :resource, class_name: 'Content::Resource'
    belongs_to :ayah,     class_name: 'Quran::Ayah'

    # scope
    scope :ordered,     ->              { joins( 'join quran.ayah on translation.ayah_key = ayah.ayah_key' ).order( 'translation.resource_id asc, ayah.surah_id asc, ayah.ayah_num asc' ) }
    scope :resource_id, ->(id_resource) { ordered.where( resource_id: id_resource ) }
    # default_scope { where resource_id: 17 } # NOTE uncomment or modify to disable/experiment on the elasticsearch import

    def self.import( options = {} )
        Content::Translation.connection.cache do
            transform = lambda do |a|
                { index: {
                        _id: "#{a.resource_id}:#{a.ayah_key}",
                    _parent: a.ayah_key,
                       data: a.__elasticsearch__.as_indexed_json.merge( { 'resource' => a.resource.__elasticsearch__.as_indexed_json, 'language' => a.resource.language.__elasticsearch__.as_indexed_json, 'source' => a.resource.source.__elasticsearch__.as_indexed_json, 'author' => a.resource.author.__elasticsearch__.as_indexed_json } )
                } }
            end

            options = { transform: transform, batch_size: 6236 }.merge( options )
            self.importing options
        end
    end
end

# notes:
# - provides a 'text' column
