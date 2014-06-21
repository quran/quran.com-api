class Quran::Ayah < ActiveRecord::Base
    extend Quran

    self.table_name = 'ayah'
    self.primary_key = 'ayah_key'
end
