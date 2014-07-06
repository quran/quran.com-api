class Content::TafsirController < ApplicationController
  def show
    @result = Content::Tafsir
    .select("content.tafsir.text")
    .find(params[:id])

  end
end
