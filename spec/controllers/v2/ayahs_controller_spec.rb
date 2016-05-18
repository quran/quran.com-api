require 'rails_helper'

RSpec.describe V2::AyahsController, type: :controller do

  describe 'GET #index' do
    Audio::Recitation.list_audio_options.map do |recitation|
      id = recitation.recitation_id

      context "getting surah al baqarah with audio #{id}" do
        before { get :index, { surah_id: 2, from: 1, to: 30, content: [19], audio: id } }

        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        it 'returns 30 ayahs' do
          expect(response_json.count).to eql(30)
        end

        it 'returns content for each ayah' do
          expect(response_json.all? { |ayah| ayah['content'].count == 1 }).to be_truthy
        end

        it 'returns words for each ayah' do
          expect(response_json.all? { |ayah| ayah['words'].present? }).to be_truthy
        end
      end
    end

  end

end
