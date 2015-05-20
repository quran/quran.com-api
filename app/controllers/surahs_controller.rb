class SurahsController < ApplicationController
  caches_page :index, :show
  caches_action :index, :show
  def index
    @results = Quran::Surah.order("quran.surah.surah_id")
  end
  def show
    @surah = Quran::Surah.find(params[:id])
  end
end
