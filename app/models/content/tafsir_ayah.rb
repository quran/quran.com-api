# vim: ts=4 sw=4 expandtab
class Content::TafsirAyah < ActiveRecord::Base
    extend Content
    extend Batchelor

    self.table_name = 'tafsir_ayah'
    self.primary_keys = :tafsir_id, :ayah_key

    # relationships
    belongs_to :tafsir, class_name: 'Content::Tafsir'
    belongs_to :ayah,   class_name: 'Quran::Ayah'

    # scope
    # default_scope { where ayah_key: -1 }

    index_name "tafsir" # NOTE we're overriding the index name from tafsir_ayah to tafsir

    def self.import( options = {} )
        Content::TafsirAyah.connection.cache do
            transform = lambda do |a|
                { index: { _id: "#{a.tafsir.resource_id}:#{a.ayah_key}", _parent: a.ayah_key, data: a.__elasticsearch__.as_indexed_json.merge( a.tafsir.__elasticsearch__.as_indexed_json ) } }
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
