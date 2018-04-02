# frozen_string_literal: true

module ResponseJSON
  def response_json
    Oj.load(response.body)
  rescue Oj::ParseError
    response.body
  end
end

RSpec.configure do |config|
  config.include ResponseJSON
end
