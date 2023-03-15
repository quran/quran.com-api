# frozen_string_literal: true

module Api::Qdc
  class ChaptersController < ApiController
    before_action :init_presenter

    def index
    end

    def show
      render
    end

    protected
    def init_presenter
      @presenter = Qdc::ChapterPresenter.new(params, fetch_locale)
    end
  end
end
