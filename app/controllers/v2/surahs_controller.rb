class V2::SurahsController < ApplicationController
  def index
    surahs = Rails.cache.fetch('surahs', expires_in: 12.hours) do
      Quran::Surah.order('quran.surah.surah_id').as_json
    end

    render json: surahs
  end

  def show
    surah = Rails.cache.fetch("surahs/#{surah_params}", expires_in: 12.hours) do
      Quran::Surah.find(surah_params).as_json
    end

    render json: surah
  end

private
  def surah_params
    params.require(:id)
  end
end
