# frozen_string_literal: true

module Api::Qdc
  class TranslationsController < Api::V4::TranslationsController
    before_action :init_presenter
    before_action :load_translations

    protected
    def init_presenter
      @presenter = Qdc::TranslationsPresenter.new(params)
    end

    def load_translations
      @translations = @presenter.translations(action_name)
    end
  end
end
