# frozen_string_literal: true

module Api::V4
  class TafsirsController < ApiController
    before_action :init_presenter
    before_action :load_tafsirs

    def by_chapter
      render partial: 'tafsirs'
    end

    def by_juz
      render partial: 'tafsirs'
    end

    def by_page
      render partial: 'tafsirs'
    end

    def by_rub
      render partial: 'tafsirs'
    end

    def by_hizb
      render partial: 'tafsirs'
    end

    def by_ayah
      render partial: 'tafsirs'
    end

    protected
    def init_presenter
      @presenter = TafsirsPresenter.new(params)
    end

    def load_tafsirs
      @tafsirs = @presenter.tafsirs(action_name)
    end
  end
end
