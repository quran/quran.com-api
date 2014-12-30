# vim: ts=4 sw=4 expandtab
class Content::Transliteration < ActiveRecord::Base
    extend Content
    extend Batchelor

    self.table_name = 'transliteration'
    self.primary_keys = :resource_id, :ayah_key

    # relationships
    belongs_to :resource, class_name: 'Content::Resource'
    belongs_to :ayah,     class_name: 'Quran::Ayah', foreign_key: 'ayah_key'

    # scope
    # default_scope { where resource_id: -1 } # NOTE uncomment or modify to disable/experiment on the elasticsearch import

    def self.import ( options = {} )
        Content::Transliteration.connection.cache do
            transform = lambda do |a|
                this_data = a.__elasticsearch__.as_indexed_json
                ayah_data = a.ayah.__elasticsearch__.as_indexed_json
                this_data.delete( 'ayah_key' )
                ayah_data.delete( 'text' )
                ayah_data[ 'ayah_key' ].gsub!( /:/, '_' )
                { index:      {
                    _id:      "#{a.resource_id}_#{ayah_data[ 'ayah_key' ]}",
                    data:     this_data.merge( { 'ayah' => ayah_data } )
                } }
            end
            options = { transform: transform, batch_size: 6236 }.merge( options )
            self.importing options
        end
    end

    # def as_indexed_json(options={})
    #     self.as_json(
    #         # methods: [:resource_info],
    #         include: {
    #             resource: {
    #                 only: [:slug, :name, :type]
    #             }
    #         }
    #     )
    # end
end
