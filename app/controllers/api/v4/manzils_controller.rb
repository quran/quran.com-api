# frozen_string_literal: true

module Api::V4
  class ManzilsController < ApiController
    def index
      @manzils = Manzil.order('manzil_number ASC')
      render
    end

    def show
      @manzil = Manzil.find_by(id: params[:id])

      if @manzil.nil?
        render_404("Manzil not found. Please select valid manzil number from 1-7")
      else
        render
      end
    end
  end
end
