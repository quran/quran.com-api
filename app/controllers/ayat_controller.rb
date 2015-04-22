class AyatController < ApplicationController
    def index
        render json: Quran::Ayah.get_ayat(params)
    end
end