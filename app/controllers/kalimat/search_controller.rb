module Kalimat
  class SearchController < ApplicationController
    #include ActionController::Base::Rendering
    include ActionController::Renderers::All
    use_renderers :json

    before_action :init_kalimat_api_client
    before_action :authorize_api_access

    def search
      render json: @api.search(search_params)
    end

    def suggest
      render json: @api.suggest(suggest_params)
    end

    protected
    def authorize_api_access
      qdc_client = qdc_api_client

      if qdc_client.blank?
        render_bad_request("Bad request. Api key is missing.")
      elsif qdc_client.rate_limited?
        render_request_error("too many requests", 429)
      else
        qdc_client.track_api_call(query: query) if query.present?
      end
    end

    def init_kalimat_api_client
      @api = KalimatApi.new(qdc_api_client)
    end

    def qdc_api_client
      @api_client ||= ApiClient.where(active: true).find_by(api_key: request.headers['api-key'])
    end

    def query
      params[:query].strip.presence if params[:query]
    end

    def search_params
      params.permit(
        :query,
        :exact_match,
        :include_text,
        :page,
        :per_page
      ).compact_blank
    end

    def suggest_params
      params.permit(
        :query,
        :debug,
        :highlight,
        :include_text,
        :page,
        :per_page
      ).compact_blank
    end
  end
end