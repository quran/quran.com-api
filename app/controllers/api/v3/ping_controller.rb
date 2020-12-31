# frozen_string_literal: true
module Api::V3
  class PingController < ApplicationController
    def ping
      render json: {
        message: "الحمد لله ,api is working fine. Please see the docs for each version for more help.",
        versions: {
            v3: 'https://quran.api-docs.io/v3/getting-started/introduction',
            v4: 'https://quran.api-docs.io/v4/getting-started/introduction',
            graphql: 'https://api.quran.com/graphql-playground'
        }
      }, status: :ok
    end
  end
end
