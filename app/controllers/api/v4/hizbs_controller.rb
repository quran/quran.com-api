# frozen_string_literal: true

module Api::V4
  class HizbsController < ApiController
    def index
      @hizbs = Hizb.order('hizb_number ASC').all
      render
    end

    def show
      @hizb = Hizb.find_by(hizb_number: params[:id])

      if @hizb.nil?
        render_404("Hizb not found. Please select valid hizb number from 1-60")
      else
        render
      end
    end
  end
end
