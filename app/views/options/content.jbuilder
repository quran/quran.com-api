json.array! @results.each do |result|
    json.language result["language_code"]
    json.name result["name"]
    json.description result["description"]
    json.is_available result["is_available"]? 1 : 0
    json.cardinality result["cardinality_type"]
    json.slug result["slug"]
    json.id result["id"].to_i
    json.type result["sub_type"]

end