class V2::SurahsController < ApplicationController

  api :GET, '/v2/surahs', 'Get all Surahs'
  api_version '2.0'
  def index
    surahs = Rails.cache.fetch('surahs', expires_in: 12.hours) do
      Quran::Surah.order('quran.surah.surah_id').as_json
    end

    render json: surahs
  end

  api :GET, '/v2/surahs/:id', 'Get a specific Surah'
  api_version '2.0'
  param :id, :number
  def show
    surah = Rails.cache.fetch("surahs/#{surah_params}", expires_in: 12.hours) do
      Quran::Surah.find(surah_params).as_json
    end

    render json: surah
  end

  api :GET, '/v2/surahs/:id/info', 'Get a details of specific Surah'
  api_version '2.0'
  param :id, :number
  def info
    #We have Surah info only in English for now. So no need to check locals from headers etc
    surah_info = Quran::Surah.find(surah_params).get_surah_info_for_language('en')

    render json: surah_info.as_json
  end

private

  def surah_params
    params.require(:id)
  end
end
