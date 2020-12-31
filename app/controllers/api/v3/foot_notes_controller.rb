# frozen_string_literal: true
module Api::V3
  class FootNotesController < ApplicationController
    # GET /foot_notes/1
    def show
      foot_note = FootNote.find(params[:id])

      render json: foot_note
    end
  end
end
