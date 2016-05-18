class SurahsController < ApplicationController
  def index
    redirect_to v2_surahs_url, status: 301
  end

  def show
    redirect_to v2_surah_url, status: 301
  end
end
