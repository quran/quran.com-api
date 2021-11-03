# frozen_string_literal: true

module Api::V3
  class ChaptersController < ApiController
    before_action :init_presenter

    def index
      render
    end

    def show
      if @presenter.chapter.nil?
        render_404
      else
        render
      end
    end

    protected

    def init_presenter
      @presenter = ChapterPresenter.new(params, fetch_locale)
    end
  end
end
