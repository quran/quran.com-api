# frozen_string_literal: true

module Api::Qdc
  class Audio::RecitationsController < ApiController
    before_action :init_presenter

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

    protected
    def init_presenter
      @presenter = ::Audio::RecitationPresenter.new(params)
    end
  end
end
