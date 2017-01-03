class PingController < ApplicationController
  def ping
    render json: 'pong', status: 200
  end
end
