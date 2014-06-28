require 'test_helper'

class OptionsControllerTest < ActionController::TestCase
  test "should get default" do
    get :default
    assert_response :success
  end

  test "should get language" do
    get :language
    assert_response :success
  end

  test "should get quran" do
    get :quran
    assert_response :success
  end

  test "should get content" do
    get :content
    assert_response :success
  end

  test "should get audio" do
    get :audio
    assert_response :success
  end

end
