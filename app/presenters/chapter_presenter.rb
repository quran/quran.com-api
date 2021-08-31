# frozen_string_literal: true

class ChapterPresenter < BasePresenter
  attr_reader :locale

  def initialize(params, locale)
    super(params)
    @locale = locale
  end

  def chapters
    finder.all_with_eager_load(locale: locale)
  end

  def chapter
    finder.find_and_eager_load(params[:id], locale: locale)
  end

  protected
  def finder
    ChapterFinder.new
  end
end
