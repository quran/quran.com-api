# frozen_string_literal: true

module Api::Qdc
  class AdvancedCopyController < ApiController
    before_action :init_presenter

    def index
      render
    end

    protected
    def init_presenter
      @presenter = Qdc::AdvanceCopyPresenter.new(params)
      @verses = @presenter.verses
    end
  end
end
