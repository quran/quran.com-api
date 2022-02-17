# frozen_string_literal: true

module Api::Qdc
  class Audio::RecitationsController < ApiController
    before_action :init_presenter, except: [:timestamp]

    def index
      render
    end

    def show
      render
    end

    def related
      render
    end

    def audio_files
      render
    end

    def timestamp
      @presenter = ::Audio::SegmentPresenter.new(params)

      render
    end

    def lookup_ayah
      @presenter = ::Audio::SegmentPresenter.new(params)

      render
    end

    def cumulative_percentile
      @presenter = ::Audio::PercentilePresenter.new(params)

      render
    end

    def ayah_duration_percentile
      @presenter = ::Audio::PercentilePresenter.new(params)

      render
    end

    protected
    def init_presenter
      @presenter = ::Audio::RecitationPresenter.new(params)
    end
  end
end
