class AyatController < ApplicationController
  caches_action :index
    def index
        render json: Quran::Ayah.get_ayat(params)
    end
end
