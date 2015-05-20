json.cache! @results, expires_in: 10.minutes do
  json.array! @results do |result|
      # json.result result
      json.bismillah_pre result.bismillah_pre
      json.page result.page
      json.ayat result.ayat
      json.name do
          json.arabic result.name_arabic
          json.simple result.name_simple
          json.complex result.name_complex
          json.english result.name_english
      end
      json.revelation do
          json.order result.revelation_order
          json.place result.revelation_place
      end
      json.id result["id"].to_i
  end
end
