module Mobile
  class TranslationsController < ApplicationController
    def index
      resources = ResourceContent.includes(:language).translations.one_verse.approved

      render json: resources, root: :data, each_serializer: Mobile::TranslationSerializer
    end

    def download

    end
  end
end
