# vim: ts=4 sw=4 expandtab
class Quran::TextToken < ActiveRecord::Base
    extend Quran
    extend Batchelor

    self.table_name = 'text_token'
    self.primary_key = 'id'

    belongs_to :ayah, class_name: 'Quran::Ayah'

    # scope
    # default_scope { where surah_id: -1 }

    def self.import(options = {})
        transform = lambda do |a|
            {index: {_id: "#{a.id}", _parent: a.ayah_key, data: a.__elasticsearch__.as_indexed_json}}
        end
        options = { transform: transform, batch_size: 6236 }.merge(options)
        self.importing options
    end
end
