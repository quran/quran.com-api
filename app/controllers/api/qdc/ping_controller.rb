# frozen_string_literal: true

module Api::Qdc
  class PingController < ApplicationController
    def ping
      render json: PingResponse.to_json, status: :ok
    end
  end
end
