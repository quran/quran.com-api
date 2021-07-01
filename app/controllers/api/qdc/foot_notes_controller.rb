# frozen_string_literal: true

module Api::Qdc
  class FootNotesController < ApiController
    def show
      @foot_note = FootNote.find(params[:id])
      render
    end
  end
end
