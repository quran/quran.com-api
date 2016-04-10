# json.cache! ['v2', params], expires_in: 12.hours do
  json.query @search.query.query
  json.total @search.total
  json.page @search.page
  json.size @search.size
  json.from @search.from + 1
  json.set! :took do
    json.total @search.delta_time
    json.elasticsearch @search.response.took.to_f / 1000
  end
  json.set! :results do
    json.array! json.results @search.response.records do |result|
      json.partial! "v2/search/ayah", locals: {ayah: result.delete(:ayah), result: result}
    end
  end
# end
