# frozen_string_literal: true

module Api::Qdc
  class Qr::AuthorsController < ApiController
    before_action :init_presenter

    def index
      render
    end

    def show
      render
    end

    def followers
      render
    end

    def followings
      render
    end

    protected
    def init_presenter
      @presenter = ::Qr::AuthorsPresenter.new(params)
    end
  end
end
