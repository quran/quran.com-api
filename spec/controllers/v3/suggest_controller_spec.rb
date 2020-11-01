# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V3::SuggestController, type: :controller do

  describe 'GET #index' do
    before do
      allow_any_instance_of(Search::Suggest).to receive(:get_suggestions).and_return('')
    end

    it 'returns http success' do
      get :index, params: { q: '' }
      expect(response).to have_http_status(:ok)
    end
  end

end
