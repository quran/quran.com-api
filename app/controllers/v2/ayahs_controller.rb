class V2::AyahsController < ApplicationController
  before_filter :validate_params
  before_filter :validate_range

  api :GET, '/v2/surahs/:surah_id/ayahs', 'Get Ayahs for a given Surah'
  api_version '2.0'
  param :surah_id, :number, required: true
  param :from, :number, desc: 'From ayah'
  param :to, :number, desc: 'To ayah'
  param :content, Array, desc: 'Content request. See /options/content for list'
  param :audio, :number, desc: 'Reciter request/ See /options/audio for list'
  def index
    response = Rails.cache.fetch(params_hash, expires_in: 12.hours) do
      ayahs = Quran::Ayah
        .preload(glyphs: {word: [:corpus, :token]})
        .preload(:text_tashkeel)
        .preload(:media_content)
        .by_range(params[:surah_id], range[0], range[1])

      ayahs.as_json_with_resources(ayahs, params)
    end

    render json: response
  end

private

  def validate_params
    params.has_key?(:quran) && valid_surah_id? && contains_range?
  end

  def contains_range?
    ((params.has_key?(:from) && params.has_key?(:to)) || params.has_key?(:range))
  end

  def valid_surah_id?
    is_surah_id_in_range?
  end

  def surah_id_integer?
    params[:surah_id].to_i > 0
  end

  def is_surah_id_in_range?
    if surah_id_integer?
      params[:surah_id].to_i > 0 && params[:surah_id].to_i < 115
    end
  end

  def validate_range
    if params.key?(:range)
      range = params[:range].split('-')
    elsif params.key?(:from) && params.key?(:to)
      range = [params[:from], params[:to]]
    end
  end

  def range
    if params.key?(:range)
      params[:range].split('-')
    elsif params.key?(:from) && params.key?(:to)
      [params[:from], params[:to]]
    else
      ['1', '10']
    end
  end

  def params_hash
    "v2/#{params[:surah_id]}" + (params[:range] || ("#{params[:from]}-#{params[:to]}")) + "/1/#{params[:audio]}/#{params[:content]}"
  end
end
