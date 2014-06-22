class Bucket::AyatController < ApplicationController
    def index
        @result = Quran::Ayah.take( 5 )
    end
end
