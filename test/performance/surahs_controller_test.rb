require 'test_helper'
require 'rails/performance_test_help'

class SurahsControllerTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  # self.profile_options = { runs: 5, metrics: [:wall_time, :memory],
  #                          output: 'tmp/performance', formats: [:flat] }

  test "surahs index" do
    get '/surahs'
  end

  test "surahs 1" do
    get '/surahs/1'
  end

  test "surahs individuals" do
    get '/surahs/1'
    get '/surahs/11'
    get '/surahs/111'
  end
end
