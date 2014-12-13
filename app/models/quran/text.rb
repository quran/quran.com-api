# vim: ts=4 sw=4 expandtab
class Quran::Text < ActiveRecord::Base
    extend Quran
    extend Batchelor

    self.table_name = 'text'
    self.primary_keys = :resource_id, :ayah_key

    # relationships
    belongs_to :resource, class_name: 'Content::Resource'
    belongs_to :ayah,     class_name: 'Quran::Ayah', foreign_key: 'ayah_key'

    # scope
    # default_scope { where resource_id: -1 }

    def self.import( options = {} )
        Quran::Text.connection.cache do
            transform = lambda do |a|
                this_data = a.__elasticsearch__.as_indexed_json
                ayah_data = a.ayah.__elasticsearch__.as_indexed_json
                this_data.delete( 'ayah_key' )
                ayah_data.delete( 'text' )
                { index:  {
                    _id:  "#{a.resource_id}:#{a.ayah_key}",
                    data: this_data.merge( { 'ayah' => ayah_data } )
                } }
            end
            options = { transform: transform, batch_size: 6236 }.merge( options )
            self.importing options
        end
    end
end
