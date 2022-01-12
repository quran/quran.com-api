# frozen_string_literal: true

module Api::Qdc
  class VersesController < Api::V4::VersesController
    before_action :init_presenter
    before_action :load_verses, except: [:random, :by_key]

    protected

    def init_presenter
      @presenter = Qdc::VersesPresenter.new(params, action_name)
    end

    def load_verses
      @verses = @presenter.verses
    end
  end
end
