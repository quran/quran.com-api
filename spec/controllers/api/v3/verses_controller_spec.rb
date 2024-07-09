require 'rails_helper'

RSpec.describe Api::V3::VersesController, type: :controller do
  describe '#index' do
    let(:_response) { get(:index, params: {chapter_id: 2, language: 'ur'}) }
    subject { _response }

    it { is_expected.to be_successful }

    context '#response' do
      subject { Oj.load(_response.body) }

      it 'returns words with correct order' do
        # second ayah ( 2:2 ) has 10 words
        v2_position = subject['verses'][1]['words'].map do |w|
          w['position']
        end

        # 2:10 has 14 words
        v10_position = subject['verses'][9]['words'].map do |w|
          w['position']
        end

        expect(v2_position).to eq (1..10).to_a
        expect(v10_position).to eq (1..14).to_a
      end

      it 'returns valid JSON' do
        pagination = {"current_page" => 1, "next_page" => 2, "prev_page" => nil, "total_pages" => 28, "total_count" => 286}

        expect(subject['verses'].length).to eq(10)
        expect(subject['meta']).to eq(pagination)
      end
    end
  end

  describe '#limit' do
    let(:_response) { get(:index, params: {chapter_id: 2, language: 'bn', limit: 2, page: 2}) }
    subject { _response }

    it { is_expected.to be_successful }

    context '#response' do
      subject { Oj.load(_response.body) }

      it 'returns valid JSON' do
        pagination = {
          "current_page" => 2, # current page in params is 2
          "next_page" => 3,
          "prev_page" => 1,
          "total_pages" => 143, # per page is 2 hence 143 pages
          "total_count" => 286
        }

        expect(subject['verses'].length).to eq(2)
        expect(subject['meta']).to eq(pagination)
      end
    end
  end

  describe '#language' do
    context '#urdu' do
      subject {
        get(:index, params: {chapter_id: 2, language: 'ur', limit: 2, page: 2})
      }

      it { is_expected.to be_successful }

      it 'returns Urdu wbw translation' do
        results = Oj.load(subject.body)
        translation = results['verses'][0]['words'][0]['translation']

        expect(translation['language_name']).to eq('urdu')
      end
    end
    context '#bengali' do
      subject {
        get(:index, params: {chapter_id: 2, language: 'bn', limit: 2, page: 2})
      }

      it { is_expected.to be_successful }

      it 'returns Bangla wbw translation' do
        results = Oj.load(subject.body)
        translation = results['verses'][0]['words'][0]['translation']

        expect(translation['language_name']).to eq('bengali')
      end
    end
    context '#fallback' do
      subject {
        get(:index, params: {chapter_id: 2, language: 'abc', limit: 2, page: 2})
      }

      it { is_expected.to be_successful }

      it 'returns English wbw translation' do
        results = Oj.load(subject.body)
        translation = results['verses'][0]['words'][0]['translation']

        expect(translation['language_name']).to eq('english')
      end
    end
  end
end
