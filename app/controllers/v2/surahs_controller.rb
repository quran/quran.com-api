class V2::SurahsController < ApplicationController
  def index
    surahs = Rails.cache.fetch('surahs', expires_in: 12.hours) do
      Quran::Surah.order('quran.surah.surah_id')
    end

    render json: surahs
  end

  def show
    surah = Rails.cache.fetch("surahs/#{surah_params}", expires_in: 12.hours) do
      Quran::Surah.find(surah_params)
    end

    render json: surah
  end

private
  def surah_params
    params.require(:id)
  end
end
