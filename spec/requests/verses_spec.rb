# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Verses', type: :request do
  describe 'GET /verses' do
    it 'works! (now write some real specs)' do
      get '/api/v3/chapters/1/verses'
      expect(response).to have_http_status(:ok)
    end
  end
end
