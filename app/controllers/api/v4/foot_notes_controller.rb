# frozen_string_literal: true
module Api::V4
  class FootNotesController < ApiController
    def show
      @foot_note = FootNote.find(params[:id])
      render
    end
  end
end
