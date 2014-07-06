class Audio::File < ActiveRecord::Base
    extend Audio

    self.table_name = 'file'
    self.primary_key = 'file_id'

    belongs_to :ayah,       class_name: 'Quran::Ayah'
    belongs_to :recitation, class_name: 'Audio::Recitation'
end
