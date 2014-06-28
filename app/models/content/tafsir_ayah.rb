class Content::TafsirAyah < ActiveRecord::Base
    extend Content

    self.table_name = 'tafsir_ayah'
    self.primary_keys = :tafsir_id, :ayah_key

    belongs_to :tafsir, class_name: 'Content::Tafsir'
    belongs_to :ayah, class_name: 'Quran::Ayah'
end
# notes:
# - a simple bridge table connecting to ayahs
#   since one tafsir can pertain to an entire contingent range of ayat, not just a single ayah
