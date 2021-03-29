# frozen_string_literal: true

class ChapterPresenter < BasePresenter
  attr_reader :locale

  def initialize(params, locale)
    super(params)
    @locale = locale
  end

  def chapters
    finder.all_with_translated_names(locale)
  end

  def chapter
    finder.find_with_translated_name(params[:id], locale)
  end

  protected
  def finder
    ChapterFinder.new
  end
end
