class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  class APIValidation < StandardError
  end

  rescue_from APIValidation, :with => :throw_the_error

  private

  def throw_the_error(error)
    render :json => {:error => error.message}, :status => :not_found
  end
end
