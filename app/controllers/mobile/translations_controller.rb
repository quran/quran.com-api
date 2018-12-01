# frozen_string_literal: true

module Mobile
  class TranslationsController < ApplicationController
    def index
      resources = ResourceContent.includes(:language).translations.one_verse.approved

      render json: resources, root: :data, each_serializer: Mobile::TranslationSerializer
    end

    def download
      resource = ResourceContent.find_by_mobile_translation_id(params[:id])
      resource.increment_download_count!

      redirect_to resource.sqlite_file_url
    end
  end
end
