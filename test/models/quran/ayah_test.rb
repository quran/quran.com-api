require 'test_helper'

class Quran::AyahTest < ActiveSupport::TestCase
  test "basic_test" do
    assert_equal 1, Quran::Ayah.first.ayah_num
  end
  # test "the truth" do
  #   assert true
  # end
end
