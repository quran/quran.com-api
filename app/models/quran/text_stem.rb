# vim: ts=4 sw=4 expandtab
class Quran::TextStem < ActiveRecord::Base
    extend Quran
    extend Batchelor

    self.table_name = 'text_stem'
    self.primary_key = 'id'

    belongs_to :ayah, class_name: 'Quran::Ayah', foreign_key: 'ayah_key'

    # scope
    # default_scope { where surah_id: -1 }

    index_name 'text-stem'

    def self.import( options = { })
        Quran::TextStem.connection.cache do
            transform = lambda do |a|
                this_data = a.__elasticsearch__.as_indexed_json
                ayah_data = a.ayah.__elasticsearch__.as_indexed_json
                this_data.delete( 'ayah_key' )
                ayah_data.delete( 'text' )
                ayah_data[ 'ayah_key' ].gsub!( /:/, '_' )
                { index:      {
                    _id:      "#{this_data['id'].gsub!( /:/, '_' )}",
                    data:     this_data.merge( { 'ayah' => ayah_data } )
                } }
            end
            options = { transform: transform, batch_size: 6236 }.merge( options )
            self.importing options
        end
    end
end
