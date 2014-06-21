class Bucket::AyatController < ApplicationController
    def index
        @result = Quran::Ayah.all
    end
end
