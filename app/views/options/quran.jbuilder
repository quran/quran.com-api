json.array! @results.each do |result|
    json.is_available result["is_available"]? 1:0
    json.cardinality result["cardinality"]
    json.slug result["slug"]
    json.name result["name"]
    json.id result["id"].to_i
    json.type result["type"]
    json.description result["description"]

end
