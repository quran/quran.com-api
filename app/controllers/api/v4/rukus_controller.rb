# frozen_string_literal: true

module Api::V4
  class RukusController < ApiController
    def index
      @rukus = Ruku.order('ruku_number ASC')
      render
    end

    def show
      @ruku = Ruku.find_by(id: params[:id])

      if @ruku.nil?
        render_404("Ruku not found. Please select valid ruku number from 1-558")
      else
        render
      end
    end
  end
end
