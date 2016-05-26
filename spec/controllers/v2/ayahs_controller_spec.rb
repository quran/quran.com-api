require 'rails_helper'

RSpec.describe V2::AyahsController, type: :controller do
  describe 'GET #index' do
    describe 'getting surahs' do
      Quran::Surah.all.each do |surah|
        id = surah.id

        context "getting surah #{id}" do
          before { get :index, { surah_id: id, from: 1, to: 30, content: [19], audio: 8 } }

          it 'returns http success and returns corret number of ayahs' do
            expect(response).to have_http_status(:success)

            if surah.ayat > 30
              expect(response_json.count).to eql(30)
            else
              expect(response_json.count).to eql(surah.ayat)
            end
          end

          it 'returns correct ayah attributes' do
            expect(response_json.all? { |ayah| ayah['content'].count == 1 }).to be_truthy
            expect(response_json.all? { |ayah| ayah['words'].present? }).to be_truthy
            expect(response_json.all? { |ayah| ayah['audio'].present? }).to be_truthy
          end
        end
      end
    end

    describe 'getting surahs with different audio' do
      Audio::Recitation.list_audio_options.each do |recitation|
        id = recitation.recitation_id

        context "getting surah al baqarah with audio #{id}" do
          before { get :index, { surah_id: 2, from: 1, to: 30, content: [19], audio: id } }

          it 'returns http success and returns corret number of ayahs' do
            expect(response).to have_http_status(:success)
            expect(response_json.count).to eql(30)
          end

          it 'returns correct ayah attributes' do
            expect(response_json.all? { |ayah| ayah['content'].count == 1 }).to be_truthy
            expect(response_json.all? { |ayah| ayah['words'].present? }).to be_truthy
          end
        end
      end

      context 'when no audio param' do
        it 'should return audio empty' do
          get :index, { surah_id: 2, from: 1, to: 30, content: [19] }

          expect(response_json.all? { |ayah| ayah.key?('audio') && ayah['audio'] == {} }).to be_truthy
        end
      end
    end

    describe 'getting surahs with different content' do
      Content::Resource.list_content_options.where(language_code: 'en').map do |resource|
        id = resource.resource_id

        context "getting surah al baqarah with content #{id}" do
          before { get :index, { surah_id: 2, from: 1, to: 30, content: [id], audio: 8 } }

          it 'returns http success and returns corret number of ayahs' do
            expect(response).to have_http_status(:success)
            expect(response_json.count).to eql(30)
          end

          it 'returns correct ayah attributes' do
            expect(response_json.all? { |ayah| ayah['content'].count == 1 }).to be_truthy
            expect(response_json.all? { |ayah| ayah['words'].present? }).to be_truthy
            expect(response_json.all? { |ayah| ayah['audio'].present? }).to be_truthy
            expect(response_json.all? { |ayah| ayah['content'].any? { |content| content['resource']['name'] == resource.name } }).to be_truthy
          end
        end
      end

      context 'no content param' do
        it 'should return empty content' do
          get :index, { surah_id: 2, from: 1, to: 30, content: [], audio: 8 }

          expect(response_json.all? { |ayah| ayah.key?('content') && ayah['content'] == [] }).to be_truthy
        end
      end

      context 'getting surah al baqarah with all english content' do
        ids = Content::Resource.list_content_options.where(language_code: 'en').map(&:id)
        before { get :index, { surah_id: 2, from: 1, to: 30, content: ids, audio: 8 } }

        it 'returns http success and returns corret number of ayahs' do
          expect(response).to have_http_status(:success)
          expect(response_json.count).to eql(30)
        end

        it 'returns correct ayah attributes' do
          expect(response_json.all? { |ayah| ayah['content'].count == ids.count }).to be_truthy
          expect(response_json.all? { |ayah| ayah['words'].present? }).to be_truthy
          expect(response_json.all? { |ayah| ayah['audio'].present? }).to be_truthy
        end
      end
    end
  end
end
