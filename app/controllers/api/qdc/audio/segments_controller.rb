# frozen_string_literal: true

module Api::Qdc
  class Audio::SegmentsController < ApiController
    before_action :init_presenter

    def lookup_ayah
      render
    end

    protected
    def init_presenter
      @presenter = ::Audio::SegmentPresenter.new(params)
    end
  end
end
