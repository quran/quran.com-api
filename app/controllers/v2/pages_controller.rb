class V2::PagesController < ApplicationController
  before_filter :page_found?

  def show
    response = Rails.cache.fetch(page_params, expires_in: 12.hours) do
      ayahs = Quran::Ayah
        .preload(glyphs: {word: [:corpus]})
        .preload(:text_tashkeel)
        .where(page_num: page_params)
        .order(:surah_id, :ayah_num)

      ayahs.as_json_with_resources(ayahs, params)
    end

    render json: response
  end

private

  def page_found?
    return head 404 if page_params.to_i < 1 || page_params.to_i > 604
  end

  def page_params
    params.require(:id)
  end

end
