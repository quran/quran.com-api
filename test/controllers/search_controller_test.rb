require 'test_helper'
require 'awesome_print'

class SearchControllerTest < ActionController::TestCase
    Rails.logger = Logger.new( STDOUT )
    test "ok response" do
        get :query, { q: 'allah light' }, nil, nil
        assert_response :success
        assert_equal 'application/json', @response.content_type
        result = JSON.parse @response.body
        assert_not_empty result
    end

    test "size param" do
        get :query, { q: 'allah light' }, nil, nil
        result = JSON.parse @response.body
        assert_equal 20, result.length


        get :query, { q: 'allah light', s: 30 }, nil, nil
        result = JSON.parse @response.body
        assert_equal 30, result.length

        get :query, { q: 'allah light', s: 50 }, nil, nil
        result = JSON.parse @response.body
        assert_equal 40, result.length # max is 40
    end

    test "page param" do
        get :query, { q: 'allah light' }, nil, nil
        result_1 = JSON.parse @response.body
        page_1_keys = result_1.map { |r| r['key'] }
        get :query, { q: 'allah light', p: 2 }, nil, nil
        result_2 = JSON.parse @response.body
        page_2_keys = result_2.map { |r| r['key'] }
        for k in page_2_keys do
            assert_not_includes page_1_keys, k
        end
    end

    test "result expected hit" do
        get :query, { 'q' => 'allah light' }, nil, nil
        result = JSON.parse @response.body

        assert_equal '24:35', result[0]['key']
        assert_equal 24, result[0]['surah']
        assert_equal 35, result[0]['ayah']
        assert_equal 2826, result[0]['index']
    end

    test "result basic attributes" do
        get :query, { 'q' => 'allah light' }, nil, nil
        result = JSON.parse @response.body
        Rails.logger.info( "response #{ ap result }" )

        assert_match /^\d+:\d+$/, result[0]['key']
        assert_not_nil result[0]['surah']
        assert_not_nil result[0]['ayah']
        assert_not_nil result[0]['index']
        assert_not_nil result[0]['score']
        assert_not_empty result[0]['match']
        assert_not_empty result[0]['bucket']
    end

    test "result match attribute" do
        get :query, { 'q' => 'allah light' }, nil, nil
        result = JSON.parse @response.body

        assert result[0]['match']['hits'] >= result[0]['match']['best'].length
        assert result[0]['match']['best'].length <= 3
        assert_not_nil result[0]['match']['best'][0]['id']
        assert_not_nil result[0]['match']['best'][0]['name']
        assert_not_nil result[0]['match']['best'][0]['slug']
        assert_not_nil result[0]['match']['best'][0]['lang']
        assert_not_nil result[0]['match']['best'][0]['dir']
        assert_not_nil result[0]['match']['best'][0]['text']
        assert_not_nil result[0]['match']['best'][0]['score']
    end

    test "result bucket quran attribute" do
        get :query, { 'q' => 'allah light' }, nil, nil
        result = JSON.parse @response.body
        assert_not_empty result[0]['bucket']['quran']
        assert_not_empty result[0]['bucket']['quran'][0]['char']
        assert_not_nil result[0]['bucket']['quran'][0]['char']['code']
        assert_match /^&#x/, result[0]['bucket']['quran'][0]['char']['code']
        assert_not_nil result[0]['bucket']['quran'][0]['char']['font']
        assert_match /^p\d+$/, result[0]['bucket']['quran'][0]['char']['font']
        assert_not_nil result[0]['bucket']['quran'][0]['char']['type']
        assert_equal 'end', result[0]['bucket']['quran'][-1]['char']['type']
        assert_not_empty result[0]['bucket']['quran'][1]['word']
        assert_not_nil result[0]['bucket']['quran'][1]['word']['id']
        assert_not_nil result[0]['bucket']['quran'][1]['word']['arabic']
        assert_not_nil result[0]['bucket']['quran'][1]['word']['translation']
    end

    test "result bucket audio attribute" do
        get :query, { 'q' => 'allah light', audio: 1 }, nil, nil
        result = JSON.parse @response.body
        assert_not_empty result[0]['bucket']['audio']
        assert_not_empty result[0]['bucket']['audio']['ogg']
        assert_not_nil result[0]['bucket']['audio']['ogg']['url']
        assert_not_nil result[0]['bucket']['audio']['ogg']['duration']
        assert_not_nil result[0]['bucket']['audio']['ogg']['mime_type']
        assert_not_empty result[0]['bucket']['audio']['mp3']
        assert_not_nil result[0]['bucket']['audio']['mp3']['url']
        assert_not_nil result[0]['bucket']['audio']['mp3']['duration']
        assert_not_nil result[0]['bucket']['audio']['mp3']['mime_type']
    end

    test "result bucket content attribute" do
        get :query, { 'q' => 'allah light', content: '19,13' }, nil, nil
        result = JSON.parse @response.body
        assert_not_empty result[0]['bucket']['content']
        assert_equal 13, result[0]['bucket']['content'][0]['id']
        assert_not_nil result[0]['bucket']['content'][0]['name']
        assert_not_nil result[0]['bucket']['content'][0]['slug']
        assert_not_nil result[0]['bucket']['content'][0]['lang']
        assert_not_nil result[0]['bucket']['content'][0]['dir']
        assert_not_nil result[0]['bucket']['content'][0]['url']

        assert_equal 19, result[0]['bucket']['content'][1]['id']
        assert_not_nil result[0]['bucket']['content'][1]['name']
        assert_not_nil result[0]['bucket']['content'][1]['slug']
        assert_not_nil result[0]['bucket']['content'][1]['lang']
        assert_not_nil result[0]['bucket']['content'][1]['dir']
        assert_not_nil result[0]['bucket']['content'][1]['text']
    end

    test "arabic query" do
        get :query, { q: 'مصباح الله نور' }, nil, nil
        result = JSON.parse @response.body
        assert_not_empty result
        assert_equal '24:35', result[0]['key']
        assert_equal 24, result[0]['surah']
        assert_equal 35, result[0]['ayah']
        assert_equal 2826, result[0]['index']
        assert_equal 'word_font', result[0]['match']['best'][0]['slug']
        assert_not_nil result[0]['bucket']['quran'][1]['highlight'] # "allah"
        assert_not_nil result[0]['bucket']['quran'][2]['highlight'] # "is the light"
        assert_not_nil result[0]['bucket']['quran'][7]['highlight'] # "of his light"
        assert_not_nil result[0]['bucket']['quran'][10]['highlight'] # "is a lamp"
        assert_not_nil result[0]['bucket']['quran'][12]['highlight'] # "the lamp"

        get :query, { q: 'اللَّهُ نُورُ' }, nil, nil
        result_with_tashkil = JSON.parse @response.body
        assert_not_empty result_with_tashkil
        assert_equal '24:35', result_with_tashkil[0]['key']
        score_with_tashkil = result_with_tashkil[0]['score']

        get :query, { q: 'الله نور' }, nil, nil
        result_without_tashkil = JSON.parse @response.body
        assert_not_empty result_without_tashkil
        assert_equal '24:35', result_without_tashkil[0]['key']
        score_without_tashkil = result_without_tashkil[0]['score']

        assert score_with_tashkil > score_without_tashkil
    end
end
