class SurahsController < ApplicationController
  caches_page :index, :show
  caches_action :index, :show
  #
  def index
    @results = Rails.cache.fetch('surahs', expires_in: 12.hours) do
      Quran::Surah.order("quran.surah.surah_id")
    end
  end

  def show
    @surah = Rails.cache.fetch("surahs/#{params[:id]}", expires_in: 12.hours) do
      Quran::Surah.find(params[:id])
    end
  end
end
