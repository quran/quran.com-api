# frozen_string_literal: true

module Api::V4
  class ManzilsController < ApiController
    def index
      @juzs = Juz.order('juz_number ASC').all
      render
    end

    def show
      @juz = Juz.find_by(id: params[:id])

      if @juz.nil?
        render_404("Juz not found. Please select valid juz number from 1-30")
      else
        render
      end
    end
  end
end
