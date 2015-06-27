class AyatController < ApplicationController
  def index
    params_hash = (params[:range] || ("#{params[:from]}-#{params[:to]}")) + "/#{params[:quran]}/#{params[:audio]}/#{params[:content]}"
    @results = Rails.cache.fetch("surahs/#{params[:surah_id]}/ayahs/#{params_hash}", expires_in: 12.hours) do
      Quran::Ayah.get_ayat(params)
    end

    render json: @results
  end
end
