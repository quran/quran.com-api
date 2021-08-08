# frozen_string_literal: true

module Api::Qdc
  class Audio::ChapterRecitationsController < ApiController
    before_action :init_presenter

    def reciters
      render
    end

    def reciter_audio_files
      render
    end

    protected
    def init_presenter
      @presenter = ::Audio::RecitationPresenter.new(params)
    end
  end
end
