# frozen_string_literal: true

module Api::V4
  class RecitationsController < ApiController
    before_action :init_presenter

    def by_chapter
      render partial: 'audio_files'
    end

    def by_juz
      render partial: 'audio_files'
    end

    def by_page
      render partial: 'audio_files'
    end

    def by_rub_el_hizb
      render partial: 'audio_files'
    end

    def by_hizb
      render partial: 'audio_files'
    end

    def by_manzil
      render partial: 'audio_files'
    end

    def by_ruku
      render partial: 'audio_files'
    end

    def by_ayah
      render partial: 'audio_files'
    end

    protected
    def init_presenter
      @presenter = RecitationsPresenter.new(params)
    end
  end
end
