class Quran::Surah < ActiveRecord::Base
    extend Quran

    self.table_name = 'surah'
    self.primary_key = 'surah_id'

    has_many :ayahs, class_name: 'Quran::Ayah', foreign_key: 'surah_id'
end
