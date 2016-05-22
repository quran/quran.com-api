class V2::PagesController < ApplicationController
  before_filter :page_found?

  api :GET, '/v2/pages/:id', 'Get Ayahs for a given page'
  api_version '2.0'
  param :id, :number, required: true, desc: 'Page id'
  param :content, Array, desc: 'Content request. See /options/content for list', required: true
  param :audio, :number, desc: 'Reciter request/ See /options/audio for list', required: true
  def show
    ayahs = Rails.cache.fetch(page_params, expires_in: 12.hours) do
      Quran::Ayah
        .includes(translations: [:resource])
        .includes(glyphs: {word: [:corpus]})
        .includes(audio: :reciter)
        .includes(:text_tashkeel)
        .includes(transliteration: [:resource])
        .where('translation.resource_id' => params_content? ? params[:content] : [])
        .where('file.recitation_id' => params[:audio], 'file.is_enabled' => true)
        .where(page_num: page_params)
        .order(:surah_id, :ayah_num)
        .map(&:view_json)
    end

    render json: ayahs
  end

private

  def page_found?
    return head 404 if page_params.to_i < 1 || page_params.to_i > 604
  end

  def page_params
    params.require(:id)
  end

  def params_content?
    params.key?(:content)
  end

end
