# vim: ts=4 sw=4 expandtab
class Content::TafsirAyah < ActiveRecord::Base
    extend Content
    extend Batchelor

    self.table_name = 'tafsir_ayah'
    self.primary_keys = :tafsir_id, :ayah_key

    # relationships
    belongs_to :tafsir, class_name: 'Content::Tafsir'
    belongs_to :ayah,   class_name: 'Quran::Ayah', foreign_key: 'ayah_key'

    # scope
    # default_scope { where ayah_key: -1 }

    index_name "tafsir" # NOTE we're overriding the index name from tafsir_ayah to tafsir

    def self.import( options = {} )
        Content::TafsirAyah.connection.cache do
            transform = lambda do |a|
                this_data = a.__elasticsearch__.as_indexed_json.merge( a.tafsir.__elasticsearch__.as_indexed_json )
                ayah_data = a.ayah.__elasticsearch__.as_indexed_json
                this_data.delete( 'ayah_key' )
                ayah_data.delete( 'text' )
                ayah_data[ 'ayah_key' ].gsub!( /:/, '_' )


                resource_data = a.tafsir.resource.__elasticsearch__.as_indexed_json
                language_data = a.tafsir.resource.language.__elasticsearch__.as_indexed_json

                {   index:   {
                    _id:     "#{a.tafsir.resource_id}_#{ayah_data[ 'ayah_key' ]}",
                    data:    this_data.merge( { 'ayah' => ayah_data, 'resource' => resource_data, 'language' => language_data } )
                } }
            end
            options = { transform: transform, batch_size: 6236 }.merge( options )
            self.importing options
        end
    end
end

# notes:
# - a simple bridge table connecting to ayahs
#   since one tafsir can pertain to an entire contingent range of ayat, not just a single ayah
# - this class is used instead of the Content::Tafsir class for importing into the elasticsearch 'tafsir' type
