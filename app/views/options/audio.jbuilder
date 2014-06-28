
json.array! @results do |result|

    json.reciter do 
        json.slug result["reciter_slug"]
        json.id result["reciter_id"]
    end
    json.name do 
        json.english result["name_english"]
        json.arabic result["name_arabic"]
    end
    json.style do 
        json.slug result["style_slug"]
        json.id result["reciter_id"]
    end
    json.id result["id"].to_i
end
