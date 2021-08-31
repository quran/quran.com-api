# frozen_string_literal: true

class ApplicationController < ActionController::API
  serialization_scope :params
  include QuranUtils::StrongMemoize

  class APIValidation < StandardError; end

  rescue_from APIValidation, with: :throw_the_error
  before_action :set_cache_headers

  private
  def throw_the_error(error)
    render json: { error: error.message }, status: :not_found
  end

  def fetch_locale
    params[:language].presence || params[:locale].presence || 'en'
  end

  def set_cache_headers
    expires_in 1.day, public: true
  end

  def eager_load_translated_name(records)
    language = Language.find_with_id_or_iso_code(fetch_locale)
    defaults = records.where(
      translated_names: { language_id: Language.default.id }
    )

    records
      .where(
        translated_names: { language_id: language }
      ).or(defaults).order('translated_names.language_priority DESC')
  end
end
