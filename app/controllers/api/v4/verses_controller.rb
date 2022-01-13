# frozen_string_literal: true

module Api::V4
  class VersesController < ApiController
    before_action :init_presenter

    def filter
      render partial: 'verses'
    end

    def by_chapter
      render partial: 'verses'
    end

    def by_juz
      render partial: 'verses'
    end

    def by_page
      render partial: 'verses'
    end

    def by_rub_el_hizb
      render partial: 'verses'
    end

    def by_hizb
      render partial: 'verses'
    end

    def by_manzil
      render partial: 'verses'
    end

    def by_ruku
      render partial: 'verses'
    end

    def random
      render partial: 'verse', locals: { verse: @presenter.random_verse }
    end

    def by_key
      render partial: 'verse', locals: { verse: @presenter.find_verse }
    end

    protected
    def init_presenter
      @presenter = VersesPresenter.new(params, action_name)
    end
  end
end
