# frozen_string_literal: true

module Api::Qdc
  class RecitationsController < Api::V4::RecitationsController
    protected
    def init_presenter
      @presenter = Qdc::RecitationsPresenter.new(params)
    end
  end
end
