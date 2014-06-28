json.array! @results do |result|
    json.direction result["direction"]
    json.name do 
        json.unicode result["name_unicode"]
        json.english result["name_english"]
    end
    json.id result["id"].to_i
end