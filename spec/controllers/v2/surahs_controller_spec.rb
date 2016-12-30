require 'rails_helper'

RSpec.describe V2::SurahsController, type: :controller do

  describe 'GET #index' do
    before { get :index }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns all the surahs' do
      expect(response_json.count).to eql(114)
    end
  end

  describe 'GET #show' do
    before { get :show, { id: 1 } }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns first surah' do
      expect(response_json['surah_id']).to eql(1)
      expect(response_json['ayat']).to eql(7)
      expect(response_json['id']).to eql(1)
    end
  end

  describe 'GET #info' do
    before { get :info, { id: 1 } }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns information of first surah' do
      expect(response_json['surah_id']).to eql(1)
    end
  end

end
