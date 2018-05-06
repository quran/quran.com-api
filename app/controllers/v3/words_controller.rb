# frozen_string_literal: true

class V3::WordsController < ApplicationController
  def show
    word = Word.includes(word_includes).find(params[:id])

    render json: word
  end

  def word_includes
    [
      eager_language('translations'),
      eager_language('transliterations')
    ]
  end
end
