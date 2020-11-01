# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Chapters', type: :request do
  describe 'GET /chapters' do
    it 'works! (now write some real specs)' do
      get '/api/v3/chapters'
      expect(response).to have_http_status(:ok)
    end
  end
end
