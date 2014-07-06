class Bucket::AyatController < ApplicationController
    def index
        @result = Quran::Ayah.where( surah_id: 1 ).order( :ayah_num )
    end
end
