# frozen_string_literal: true

module Api::Qdc
  class VersesController < Api::V4::VersesController
    before_action :init_presenter

    def by_range
      render partial: 'verses'
    end

    protected
    def init_presenter
      @presenter = Qdc::VersesPresenter.new(params, action_name)
    end
  end
end
