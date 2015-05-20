class Quran::Surah < ActiveRecord::Base
    extend Quran

    self.table_name = 'surah'
    self.primary_key = 'surah_id'

    has_many :ayahs, class_name: 'Quran::Ayah', foreign_key: 'surah_id'

    # def self.as_json
    #   self.
    #   json.array! @results do |result|
    #       # json.result result
    #       json.bismillah_pre result.bismillah_pre
    #       json.page result.page
    #       json.ayat result.ayat
    #       json.name do
    #           json.arabic result.name_arabic
    #           json.simple result.name_simple
    #           json.complex result.name_complex
    #           json.english result.name_english
    #       end
    #       json.revelation do
    #           json.order result.revelation_order
    #           json.place result.revelation_place
    #       end
    #       json.id result["id"].to_i
    #   end
    #
    # end

end
