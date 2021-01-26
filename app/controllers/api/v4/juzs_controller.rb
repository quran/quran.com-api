# frozen_string_literal: true

module Api::V4
  class JuzsController < ApiController
    def index
      @juzs = Juz.order('juz_number ASC').all
      render
    end

    def show
      @juz = Juz.find(params[:id])
      render
    end
  end
end
