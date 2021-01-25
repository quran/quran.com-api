# frozen_string_literal: true

module Api::V4
  class TranslationsController < ApiController
    before_action :init_presenter
    before_action :load_translations

    def by_chapter
      render partial: 'translations'
    end

    def by_juz
      render partial: 'translations'
    end

    def by_page
      render partial: 'translations'
    end

    def by_rub
      render partial: 'translations'
    end

    def by_hizb
      render partial: 'translations'
    end

    def by_ayah
      render partial: 'translations'
    end

    protected
    def init_presenter
      @presenter = TranslationsPresenter.new(params)
    end

    def load_translations
      @translations = @presenter.translations(action_name)
    end
  end
end
