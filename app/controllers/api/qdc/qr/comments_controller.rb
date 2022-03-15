# frozen_string_literal: true

module Api::Qdc
  class Qr::CommentsController < ApiController
    before_action :init_presenter

    def index
      render
    end

    def show
      render
    end

    def replies
      render
    end

    protected
    def init_presenter
      @presenter = ::Qr::CommentsPresenter.new(params)
    end
  end
end
