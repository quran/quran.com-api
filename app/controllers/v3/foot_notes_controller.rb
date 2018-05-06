# frozen_string_literal: true

class V3::FootNotesController < ApplicationController
  # GET /foot_notes/1
  def show
    foot_note = FootNote.find(params[:id])

    render json: foot_note
  end
end
