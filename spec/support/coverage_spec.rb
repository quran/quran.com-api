# frozen_string_literal: true
=begin
RSpec.configure do |config|
  config.after(:suite) do
    example_group = RSpec.describe('Code coverage')

    example_group.example('must be above 70%') do
      expect(SimpleCov.result.covered_percent).to be > 70
    end

    example_group.run(RSpec.configuration.reporter)
  end
end
=end
