# frozen_string_literal: true

module Api::V3
  class FootNotesController < ApiController
    # GET /foot_notes/1
    def show
      @foot_note = FootNote.find(params[:id])

      render
    end
  end
end
