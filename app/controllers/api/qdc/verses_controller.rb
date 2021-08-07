# frozen_string_literal: true

module Api::Qdc
  class VersesController < ApiController
    before_action :init_presenter
    before_action :load_verses, except: [:random, :by_key]

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

    def by_rub
      render partial: 'verses'
    end

    def by_hizb
      render partial: 'verses'
    end

    def random
      render partial: 'verse', locals: { verse: @presenter.random_verse(fetch_locale) }
    end

    def by_key
      render partial: 'verse', locals: { verse: @presenter.find_verse('by_key', fetch_locale) }
    end

    protected
    def init_presenter
      lookahead = RestApi::ParamLookahead.new(params)
      @presenter = VersesPresenter.new(params, lookahead)
    end

    def load_verses
      @verses = @presenter.verses(action_name, fetch_locale)
    end
  end
end
