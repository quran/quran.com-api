# frozen_string_literal: true

module Api::Qdc
  class PagesController < ApiController
    before_action :init_presenter

    def index
      render
    end

    def show
      render
    end

    protected
    def init_presenter
      @presenter = Qdc::MushafPagePresenter.new(params)
    end
  end
end
