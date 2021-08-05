# frozen_string_literal: true

module Api::Qdc
  class AdvancedCopyController < ApiController
    before_action :init_presenter

    def index
      render
    end

    def raw_text
      render
    end

    protected
    def init_presenter
      lookahead = RestApi::ParamLookahead.new(params)
      @presenter = Qdc::AdvanceCopyPresenter.new(params, lookahead)

      @verses = @presenter.verses('advance_copy', fetch_locale)
    end
  end
end
