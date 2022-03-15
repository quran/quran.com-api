# frozen_string_literal: true

module Api::Qdc
  class Qr::TagsController < ApiController
    before_action :init_presenter

    def index
      render
    end

    protected
    def init_presenter
      @presenter = ::Qr::TagsPresenter.new(params)
    end
  end
end
