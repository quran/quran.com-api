# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Caching
  include QuranUtils::StrongMemoize
  include ActionView::Rendering

  before_action :set_cache_headers
  before_action :set_default_response_format

  rescue_from RestApi::RecordNotFound, with: :render_404

  protected
  def set_default_response_format
    request.format = :json
  end

  def raise_not_found(message)
    raise RestApi::RecordNotFound.new(message)
  end

  def render_404(error=nil)
    render partial: "api/errors/404", locals: { message: error.to_s }, status: :not_found
  end

  def fetch_locale
    params[:language].presence || params[:locale].presence || 'en'
  end

  def set_cache_headers
    if action_name != 'random'
      expires_in 7.day, public: true
      # https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security
      headers['Strict-Transport-Security'] = 'max-age=31536000; includeSubDomains; preload'
    end

    headers['Access-Control-Allow-Origin'] = '*'
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
