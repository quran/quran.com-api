module Api::Qdc
  class Audio::PercentilesController < ApiController
    before_action :init_presenter

    def cumulative_percentile
      render
    end

    def ayah_duration_percentile
      render
    end

    protected
    def init_presenter
      @presenter = ::Audio::PercentilePresenter.new(params)
    end
  end
end