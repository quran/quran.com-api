class AyatController < ApplicationController
  def index
    params_hash = (params[:range] || ("#{params[:from]}-#{params[:to]}")) + "/#{params[:quran]}/#{params[:audio]}/#{params[:content]}"

    if params.key?(:range)
      range = params[:range].split('-')
    elsif params.key?(:from) && params.key?(:to)
      range = [params[:from], params[:to]]
    else
      range = ['1', '10']
    end

    if (range.last.to_i - range.first.to_i) > 50
      return render json: {error: "Range invalid, use a string (maximum 50 ayat per request), e.g. '1-3'"}
    end

    @results = Rails.cache.fetch("surahs/#{params[:surah_id]}/ayahs/#{params_hash}", expires_in: 12.hours) do
      ayahs = Quran::Ayah.get_ayahs_by_range(params[:surah_id], range[0], range[1])
      Quran::Ayah.merge_resource_with_ayahs(params, ayahs)
    end

    render json: @results
  end
end
