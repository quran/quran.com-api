class ApplicationController < ActionController::Base

  class APIValidation < StandardError
  end

  rescue_from APIValidation, :with => :throw_the_error

  rescue_from Apipie::Error, with: :throw_apipie_error

  private

  def throw_apipie_error(error)
    render json: {error: error.as_json.slice('param', 'value', 'error')}, status: :bad_request
  end

  def throw_the_error(error)
    render :json => {:error => error.message}, :status => :not_found
  end
end
