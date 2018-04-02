# frozen_string_literal: true

class ApplicationController < ActionController::API
  serialization_scope :params

  class APIValidation < StandardError; end

  rescue_from APIValidation, with: :throw_the_error
  before_action :set_cache_headers

  private

    def throw_the_error(error)
      render json: { error: error.message }, status: :not_found
    end

    def eager_language(type)
      "#{params[:language] || 'en'}_#{type}".to_sym
    end

    def set_cache_headers
      expires_in 1.day, public: true
    end
end
