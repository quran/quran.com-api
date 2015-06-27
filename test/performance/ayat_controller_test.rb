require 'test_helper'
require 'rails/performance_test_help'

class AyatControllerTest < ActionDispatch::PerformanceTest
  # Refer to the documentation for all available options
  # self.profile_options = { runs: 5, metrics: [:wall_time, :memory],
  #                          output: 'tmp/performance', formats: [:flat] }

  test "ayat with all options" do
    get '/surahs/3/ayat?quran=1&from=1&to=15&content=21&audio=8'
  end
end
