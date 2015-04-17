require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  it 'should get results' do
    get :query, { q: 'allah light' }
    expect(response).to be_success
    expect(response.content_type).to eql('application/json')
    expect(response.body).not_to be nil
  end

  it 'should allow different size params' do
    get :query, {q: 'allah light'}
    expect(JSON.parse(response.body)['results'].length).to eql(20)

    get :query, {q: 'allah light', s: 30}
    expect(JSON.parse(response.body)['results'].length).to eql(30)

    get :query, {q: 'allah light', s: 50}
    expect(JSON.parse(response.body)['results'].length).to eql(40) # max is 40
  end

  it 'should allow page params' do
    get :query, {q: 'allah light'}
    result_1 = JSON.parse(response.body)['results']
    page_1_keys = result_1.map { |r| r['key'] }

    get :query, {q: 'allah light', p: 2}
    result_2 = JSON.parse(response.body)['results']
    page_2_keys = result_2.map { |r| r['key'] }

    for k in page_2_keys do
        expect(page_1_keys).not_to include(k)
    end
  end

  it 'should return expected hit' do
    get :query, {'q' => 'allah light'}
    result = JSON.parse(response.body)['results']

    expect(result[0]['key']).to eql('24:35')
    expect(result[0]['surah']).to eql(24)
    expect(result[0]['ayah']).to eql(35)
    expect(result[0]['index']).to eql(2826)
  end

  it 'should contain basic attribute' do
    get :query, {'q' => 'allah light'}
    result = JSON.parse(response.body)['results']

    expect(result[0]['key']).to match(/^\d+:\d+$/)
    expect(result[0]['surah']).not_to be_nil
    expect(result[0]['ayah']).not_to be_nil
    expect(result[0]['index']).not_to be_nil
    expect(result[0]['score']).not_to be_nil
    expect(result[0]['match']).not_to be_empty
    expect(result[0]['bucket']).not_to be_empty
  end

  it 'should contain match attribute' do
    get :query, {'q' => 'allah light'}
    result = JSON.parse(response.body)['results']

    expect(result[0]['match']['hits']).to be >= result[0]['match']['best'].length
    expect(result[0]['match']['best'].length).to be <= 3
    expect(result[0]['match']['best'][0]['id']).not_to be_nil
    expect(result[0]['match']['best'][0]['name']).not_to be_nil
    expect(result[0]['match']['best'][0]['slug']).not_to be_nil
    expect(result[0]['match']['best'][0]['lang']).not_to be_nil
    expect(result[0]['match']['best'][0]['dir']).not_to be_nil
    expect(result[0]['match']['best'][0]['text']).not_to be_nil
    expect(result[0]['match']['best'][0]['score']).not_to be_nil
  end

  it "should result bucket quran attribute" do
      get :query, {'q' => 'allah light'}
      result = JSON.parse(response.body)['results']

      expect(result[0]['bucket']['quran']).not_to be_empty
      expect(result[0]['bucket']['quran'][0]['char']).not_to be_empty
      expect(result[0]['bucket']['quran'][1]['word']).not_to be_empty

      expect(result[0]['bucket']['quran'][0]['char']['code']).to match(/^&#x/)
      expect(result[0]['bucket']['quran'][0]['char']['font']).to match(/^p\d+$/)

      expect(result[0]['bucket']['quran'][-1]['char']['type']).to eql('end')

      expect(result[0]['bucket']['quran'][0]['char']['font']).not_to be_nil
      expect(result[0]['bucket']['quran'][0]['char']['type']).not_to be_nil
      expect(result[0]['bucket']['quran'][0]['char']['code']).not_to be_nil
      expect(result[0]['bucket']['quran'][1]['word']['id']).not_to be_nil
      expect(result[0]['bucket']['quran'][1]['word']['arabic']).not_to be_nil
      expect(result[0]['bucket']['quran'][1]['word']['translation']).not_to be_nil
  end

  it "should result bucket audio attribute" do
      get :query, { 'q' => 'allah light', audio: 1 }, nil, nil
      result = JSON.parse(response.body)['results']

      expect(result[0]['bucket']['audio']).not_to be_empty
      expect(result[0]['bucket']['audio']['ogg']).not_to be_empty
      expect(result[0]['bucket']['audio']['ogg']['url']).not_to be_nil
      expect(result[0]['bucket']['audio']['ogg']['duration']).not_to be_nil
      expect(result[0]['bucket']['audio']['ogg']['mime_type']).not_to be_nil
      expect(result[0]['bucket']['audio']['mp3']).not_to be_empty
      expect(result[0]['bucket']['audio']['mp3']['url']).not_to be_nil
      expect(result[0]['bucket']['audio']['mp3']['duration']).not_to be_nil
      expect(result[0]['bucket']['audio']['mp3']['mime_type']).not_to be_nil
  end

  it "should result bucket content attribute" do
      get :query, { 'q' => 'allah light', content: '19,13' }, nil, nil
      result = JSON.parse(response.body)['results']

      Rails.logger.info result

      expect(result[0]['bucket']['content']).not_to be_empty
      expect(result[0]['bucket']['content'][0]['id']).to eql(13)
      expect(result[0]['bucket']['content'][0]['name']).not_to be_nil
      expect(result[0]['bucket']['content'][0]['slug']).not_to be_nil
      expect(result[0]['bucket']['content'][0]['lang']).not_to be_nil
      expect(result[0]['bucket']['content'][0]['dir']).not_to be_nil
      expect(result[0]['bucket']['content'][0]['url']).not_to be_nil

      expect(result[0]['bucket']['content'][1]['id']).to eql(19)
      expect(result[0]['bucket']['content'][1]['name']).not_to be_nil
      expect(result[0]['bucket']['content'][1]['slug']).not_to be_nil
      expect(result[0]['bucket']['content'][1]['lang']).not_to be_nil
      expect(result[0]['bucket']['content'][1]['dir']).not_to be_nil
      expect(result[0]['bucket']['content'][1]['text']).not_to be_nil
  end

  it "should allow arabic query" do
      get :query, { q: 'مصباح الله نور' }, nil, nil
      result = JSON.parse(response.body)['results']

      expect(result).not_to be_empty
      expect(result[0]['key']).to eql('24:35')
      expect(result[0]['surah']).to eql(24)
      expect(result[0]['ayah']).to eql(35)
      expect(result[0]['index']).to eql(2826)
      expect( result[0]['match']['best'][0]['slug']).to eql('word_font')
      expect(result[0]['bucket']['quran'][1]['highlight']).not_to be_nil # "allah"
      expect(result[0]['bucket']['quran'][2]['highlight']).not_to be_nil # "is the light"
      expect(result[0]['bucket']['quran'][7]['highlight']).not_to be_nil # "of his light"
      expect(result[0]['bucket']['quran'][10]['highlight']).not_to be_nil # "is a lamp"
      expect(result[0]['bucket']['quran'][12]['highlight']).not_to be_nil # "the lamp"

      get :query, { q: 'اللَّهُ نُورُ' }, nil, nil
      result_with_tashkil = JSON.parse(response.body)['results']

      expect(result_with_tashkil).not_to be_empty
      expect(result_with_tashkil[0]['key']).to eql('24:35')
      score_with_tashkil = result_with_tashkil[0]['score']

      get :query, { q: 'الله نور' }, nil, nil
      result_without_tashkil = JSON.parse(response.body)['results']
      expect(result_without_tashkil).not_to be_empty
      expect(result_without_tashkil[0]['key']).to eql('24:35')

      score_without_tashkil = result_without_tashkil[0]['score']
      expect(score_with_tashkil).to be > score_without_tashkil
  end

end
