# frozen_string_literal: true

module Api::Qdc
  class TafsirsController < Api::V4::TafsirsController
    protected
    def init_presenter
      @presenter = Qdc::TafsirsPresenter.new(params)
    end
  end
end
