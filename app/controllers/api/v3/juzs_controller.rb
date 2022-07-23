# frozen_string_literal: true

module Api::V3
  class JuzsController < ApiController
    before_action :init_presenter

    def index
      render
    end

    def show
      if @presenter.exists?
        render
      else
        render_404("Juz not found. Please select valid juz number from 1-30")
      end
    end

    protected
    def init_presenter
      @presenter = JuzsPresenter.new(params)
    end
  end
end
