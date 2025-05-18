# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Caching
  include QuranUtils::StrongMemoize

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

  def render_bad_request(error=nil, status=:bad_request)
    render partial: "api/errors/bad_request", locals: { message: error.to_s }, status: status
  end

  def render_422(error=nil)
    render partial: "api/errors/422", locals: { message: error.to_s }, status: :unprocessable_entity
  end

  def render_request_error(error, status)
    render partial: "api/errors/requst_error", locals: { message: error.to_s, status: status }, status: status
  end

  def fetch_locale
    params[:language].presence || params[:locale].presence || 'en'
  end

  def set_cache_headers
    headers['Cache-Control'] = 'no-store, no-cache, max-age=0, private, must-revalidate'
    headers['Pragma'] = 'no-cache'
    headers['Expires'] = '0'

    # Keep HSTS header
    headers['Strict-Transport-Security'] = 'max-age=31536000; includeSubDomains; preload'

    # Keep CORS header
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

  def after_timestamp
    if time = params[:updated_after].presence
      time !~ /\D/ ? DateTime.strptime(time, '%s') : Time.parse(time)
    end
  end
end
