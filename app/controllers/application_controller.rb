# frozen_string_literal: true

class ApplicationController < ActionController::API
  serialization_scope :params
  include ActionController::Caching
  include QuranUtils::StrongMemoize

  before_action :set_cache_headers, except: :random

  rescue_from RestApi::RecordNotFound, with: :render_404

  protected

  def render_404(error)
    render partial: "api/errors/404", locals: { message: error.message }, status: :not_found
  end

  def fetch_locale
    params[:language].presence || params[:locale].presence || 'en'
  end

  def set_cache_headers
    expires_in 7.day, public: true
    headers['Connection'] = 'Keep-Alive'
    # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security
    headers['Strict-Transport-Security'] = 'max-age=31536000; includeSubDomains; preload'
  end

  def eager_load_translated_name(records)
    language = Language.find_with_id_or_iso_code(fetch_locale)
    defaults = records.where(
      translated_names: { language_id: Language.default.id }
    )

    if language.nil? || language.default?
      defaults
    else
      records
        .where(
          translated_names: { language_id: language }
        )
        .or(defaults)
        .order('translated_names.language_priority DESC')
    end
  end
end
