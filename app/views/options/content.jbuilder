json.array! @results.each do |result|
    json.lanuage result["language"]
    json.name result["name"]
    json.description result["description"]
    json.is_available result["is_available"]? 1 : 0
    json.cardinality result["cardinality"]
    json.slug result["slug"]
    json.id result["id"].to_i
    json.type result["type"]

end