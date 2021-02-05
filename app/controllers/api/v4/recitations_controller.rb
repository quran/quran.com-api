# frozen_string_literal: true

module Api::V4
  class RecitationsController < ApiController
    before_action :init_presenter
    before_action :load_recitation

    def by_chapter
      render partial: 'audio_files'
    end

    def by_juz
      render partial: 'audio_files'
    end

    def by_page
      render partial: 'audio_files'
    end

    def by_rub
      render partial: 'audio_files'
    end

    def by_hizb
      render partial: 'audio_files'
    end

    def by_ayah
      render partial: 'audio_files'
    end

    protected
    def init_presenter
      @presenter = RecitationsPresenter.new(params)
    end

    def load_recitation
      @audio_files = @presenter.audio_files(action_name)
    end
  end
end
