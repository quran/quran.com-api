# frozen_string_literal: true

module Api::V3
  class TafsirsController < ApplicationController
    # GET /chapter_id/verses/verse_number/tafsirs/tafsir_id
    def show
      tafsir = Tafsir
                   .where(verse_id: verse.id)
                   .find_by(resource_content_id: tafisr_id)

      render json: tafsir
    end

    protected
    def verse
      finder = VerseFinder.new(params)

      finder.find(params[:id], fetch_locale)
    end

    def tafisr_id
      ResourceContent
          .where(id: params[:tafsir])
          .or(ResourceContent.where(slug: params[:tafsir]))
          .first
          .id
    end
  end
end
