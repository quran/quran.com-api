# frozen_string_literal: true

module Api::V4
  class JuzsController < ApiController
    def index
      @juzs = Juz.order('juz_number ASC').all
      render
    end

    protected
    def chapters
      finder = ChapterFinder.new
      finder.all_with_translated_names(fetch_locale)
    end

    def chapter
      finder = ChapterFinder.new
      finder.find_with_translated_name(params[:id], fetch_locale)
    end
  end
end
