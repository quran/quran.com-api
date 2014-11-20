class Content::TafsirAyah < ActiveRecord::Base
    extend Content
    extend Batchelor

    self.table_name = 'tafsir_ayah'
    self.primary_keys = :tafsir_id, :ayah_key

    belongs_to :tafsir, class_name: 'Content::Tafsir'
    belongs_to :ayah, class_name: 'Quran::Ayah'

    ########## ES FUNCTIONS ##################################################
    document_type "tafsir"
    mapping :_parent => { :type => 'ayah' }, :_routing => { :path => 'ayah_key', :required => true } do
      indexes :resource_id, type: "integer"
      indexes :ayah_key
      indexes :text, term_vector: "with_positions_offsets_payloads"
    end

    def self.import( options = {} )
        transform = lambda do |a|
            { index: { _id: "#{a.tafsir.resource_id},#{a.ayah_key}", _parent: a.ayah_key, data: a.__elasticsearch__.as_indexed_json.merge( a.tafsir.__elasticsearch__.as_indexed_json ) } }
        end
        options = { transform: transform, batch_size: 6236 }.merge( options )
        self.importing options
    end
end
# notes:
# - a simple bridge table connecting to ayahs
#   since one tafsir can pertain to an entire contingent range of ayat, not just a single ayah
# - this class is used instead of the Content::Tafsir class for importing into the elasticsearch 'tafsir' type
