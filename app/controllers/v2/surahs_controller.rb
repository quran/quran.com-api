class V2::SurahsController < ApplicationController
  caches_action :index, :show, expires_in: 3.days

  def index
    @surahs = Quran::Surah.order('quran.surah.surah_id')
  end

  def show
    @surah = Quran::Surah.find(params[:id])
  end
end
