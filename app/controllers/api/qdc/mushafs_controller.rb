# frozen_string_literal: true

module Api::Qdc
  class MushafsController < ApiController
    before_action :init_presenter

    def index
      render
    end

    protected
    def init_presenter
      @presenter = Qdc::MushafPresenter.new(params)
    end
  end
end
