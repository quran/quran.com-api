module ResponseJSON
  def response_json
    JSON.parse(response.body)
  rescue Oj::ParseError
    response.body
  end
end

RSpec.configure do |config|
  config.include ResponseJSON
end
