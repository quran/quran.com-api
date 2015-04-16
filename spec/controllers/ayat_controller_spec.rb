require 'rails_helper'
Rails.logger = Logger.new( STDOUT )
RSpec.describe AyatController, type: :controller do
  it 'should return ayahs' do
    get :index, {surah_id: 1, range: '1-5', quran: 1, content: 21, audio: 8}

    expect(response).to be_success
    expect(response.body).not_to be nil
  end

  it 'should return audio with ayahs' do
    get :index, {surah_id: 1, range: '1-5', audio: 8}

    expect(JSON.parse(response.body).first.has_key?('audio')).to be_truthy
  end

  it 'should return content with ayahs' do
    get :index, {surah_id: 1, range: '1-5', content: 21}

    expect(JSON.parse(response.body).first.has_key?('content')).to be_truthy
  end

  it 'should return multiple contents with ayahs' do
    get :index, {surah_id: 1, range: '1-5', content: '21, 16'}

    expect(JSON.parse(response.body).first.has_key?('content')).to be_truthy
    expect(JSON.parse(response.body).first['content'].length).to be > 1
  end

  it 'should turn quran font rendering' do
    get :index, {surah_id: 1, range: '1-5', quran: 1}

    expect(JSON.parse(response.body).first.has_key?('quran')).to be_truthy
    expect(JSON.parse(response.body).first['quran'].length).to eql 5
    expect(JSON.parse(response.body).first['quran'].first.has_key?('word')).to be_truthy
    expect(JSON.parse(response.body).first['quran'].first.has_key?('char')).to be_truthy
  end

  describe 'range' do
    it 'should accept range params' do
      get :index, {surah_id: 1, range: '1-5'}

      expect(JSON.parse(response.body).length).to eql(5)
    end

    it 'should accept from/to params' do
      get :index, {surah_id: 1, from: '1', to: '5'}

      expect(JSON.parse(response.body).length).to eql(5)
    end

    it 'should default to range 10' do
      get :index, {surah_id: 2}

      expect(JSON.parse(response.body).length).to eql(10)
    end

    it 'should render the correct starting and ending ayah' do
      get :index, {surah_id: 2, range: '90-100'}
      expect(JSON.parse(response.body).first['ayah']).to eql(90)
      expect(JSON.parse(response.body).last['ayah']).to eql(100)
    end

    it 'should raise error when range beyond 50' do
      get :index, {surah_id: 2, range: '1-52'}

      expect(JSON.parse(response.body).has_key?('error')).to be_truthy
      expect(response).to have_http_status(404)
    end
  end
end