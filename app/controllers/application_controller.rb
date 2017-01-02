class ApplicationController < ActionController::API
  serialization_scope :current_language

  class APIValidation < StandardError
  end

  rescue_from APIValidation, with: :throw_the_error

  private
  def throw_the_error(error)
    render :json => {:error => error.message}, :status => :not_found
  end

  def detect_language

  end

  def current_language
    lang = params[:language] || :en
    Language.find_by(iso_code: lang)
  end
end
