class AyatController < ApplicationController
  def index
    redirect_to v2_surah_ayahs_url, status: 301
  end
end
