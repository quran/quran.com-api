# frozen_string_literal: true
module Api::V4
  class VersesController < ApiController
    before_action :init_presenter
    before_action :load_verses, except: :random

    def by_chapter
      render partial: 'verses'
    end

    def by_juz
      render partial: 'verses'
    end

    def by_page
      render partial: 'verses'
    end

    def random
      render partial: 'verse', locals: {verse: @presenter.random_verse(fetch_locale)}
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


