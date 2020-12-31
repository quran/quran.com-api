# frozen_string_literal: true
module Api::V3
  class PingController < ApplicationController
    def ping
      render json: {
        docs: 'https://quran.api-docs.io/v3/getting-started/introduction',
        message: "الحمد لله api is working. Please see the docs to use this api."
      }, status: :ok
    end
  end
end
