json.cache! @results do
  json.array! @results do |result|
      json.direction result["direction"]
      json.name do
          json.unicode result["unicode"]
          json.english result["english"]
      end
      json.id result["language_code"]
  end
end
