# frozen_string_literal: true

class V3::PingController < ApplicationController
  def ping
    render json: 'pong', status: :ok
  end
end
