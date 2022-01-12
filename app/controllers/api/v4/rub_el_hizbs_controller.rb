# frozen_string_literal: true

module Api::V4
  class RubElHizbsController < ApiController
    def index
      @rub_el_hizbs = RubElHizb.order('rub_el_hizb_number ASC').all
      render
    end

    def show
      @rub_el_hizb = RubElHizb.find_by(rub_el_hizb_number: params[:id])

      if @rub_el_hizb.nil?
        render_404("Rub el Hizb not found. Please select valid rub el hizb number from 1-240")
      else
        render
      end
    end
  end
end
