# frozen_string_literal: true

module Api::Qdc
  class Audio::SectionsController < ApiController
    before_action :init_presenter

    def index
      render
    end

    protected
    def init_presenter
      @presenter = ::Audio::SectionPresenter.new(params)
    end
  end
end
