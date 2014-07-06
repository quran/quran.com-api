require 'test_helper'

class InfoControllerTest < ActionController::TestCase
  test "should get surahs" do
    get :surahs
    assert_response :success
  end

end
