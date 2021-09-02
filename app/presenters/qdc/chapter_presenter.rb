# frozen_string_literal: true

module Qdc
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
      strong_memoize :chapter do
        finder.find_and_eager_load(params[:id], locale: locale, include_slugs: include_slugs?)
      end
    end

    def include_slugs?
      include_in_response? params[:slugs]
    end

    def include_translated_names?
      include_in_response? params[:translated_names]
    end

    def include_chapter_info?
      include_in_response? params[:info]
    end

    def chapter_info
      ChapterInfo
        .where(chapter_id: chapter.id)
        .filter_by_language_or_default(fetch_locale)
    end

    protected

    def finder
      ChapterFinder.new
    end
  end
end
