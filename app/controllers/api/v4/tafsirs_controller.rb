# frozen_string_literal: true

module Api::V4
  class TafsirsController < ApiController
    before_action :init_presenter

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

    def by_manzil
      render partial: 'tafsirs'
    end

    def by_ruku
      render partial: 'tafsirs'
    end

    def by_ayah
      render
    end

    protected
    def init_presenter
      @presenter = TafsirsPresenter.new(params)
    end
  end
end
