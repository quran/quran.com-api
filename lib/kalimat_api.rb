require 'faraday'

class KalimatApi
  BASE_PATH = 'https://api.kalimat.dev:443'
  attr_reader :api_client

  def initialize(api_client)
    @api_client = api_client
  end

  def search(params)
    result_count = per_page(params[:per_page])

    api_params = {
      query: params[:query],
      numResults: result_count,
      start: calculate_offset(result_count, params[:page]),
      exactMatchesOnly: params[:exact_match] || 0,
      getText: params[:include_text] || 0,
    }

    send_request('search', api_params)
  end

  def suggest(params)
    result_count = per_page(params[:per_page])

    api_params = {
      query: params[:query],
      numResults: result_count,
      start: calculate_offset(result_count, params[:page]),
      highlight: params[:highlight] || 0,
      getText: params[:include_text] || 0,
      debug: params[:debug] || 0
    }

    send_request('search_as_you_type', api_params)
  end

  protected

  def per_page(result_count)
    val = (result_count.presence || 20).to_i.abs

    [val, 100].min
  end

  def calculate_offset(result_count, current_page)
    result_count.to_i * current_page.to_i
  end

  def send_request(path, params)
    api_key = kalimat_api_key

    url = "#{BASE_PATH}/#{path}"
    headers = {
      'x-api-key' => api_key,
      'Accept' => 'application/json'
    }

    process_response Faraday.get(url, params, headers)
  end

  def process_response(response)
    if response.status == 200
      Oj.load response.body
    else
      {
        status: response.status,
        message: api_error_message(response.status)
      }
    end
  end

  def api_error_message(code)
    case code.to_i
    when 500
      "Internal Server Error."
    when 503
      "A problem to handle your request, due to over capacity or unavailability."
    when 401
      "Unauthorized."
    when 505
      "A problem to handle your request, due to over capacity or unavailability."
    end
  end

  def kalimat_api_key
    api_client.kalimat_api_key.presence || ENV['KALIMAT_API_KEY']
  end
end