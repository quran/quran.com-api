# frozen_string_literal: true

module Api::V3
  class JuzsController < ApiController
    def index
      @juzs = Juz.order('juz_number ASC').all
      render
    end

    def show
      @juz = Juz.find_by(id: params[:id])

      if @juz.nil?
        render_404("Juz not found")
      else
        render
      end
    end
  end
end
