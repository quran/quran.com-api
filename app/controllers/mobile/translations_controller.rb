class Mobile::TranslationsController < ApplicationController
  def index
    resources = ResourceContent.includes(:language).translations.one_verse.approved

    render json: resources, root: :data
  end

  def download

  end
end
