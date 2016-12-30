class ApplicationController < ActionController::API

  class APIValidation < StandardError
  end

  rescue_from APIValidation, with: :throw_the_error

  private

  def throw_the_error(error)
    render :json => {:error => error.message}, :status => :not_found
  end
end
