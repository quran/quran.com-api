# frozen_string_literal: true

module Api::V3
  class TafsirsController < ApiController
    # GET /chapter_id/verses/verse_number/tafsirs/tafsir_id
    def show
      @tafsir = Tafsir
                  .where(verse_id: verse.id)
                  .find_by(resource_content_id: tafisr_id)

      render
    end

    protected

    def verse
      finder = VerseFinder.new(params)

      finder.find(params[:id], fetch_locale)
    end

    def tafisr_id
      approved_tafsir = ResourceContent
                        .tafsirs
                        .approved
                        .allowed_to_share

      tafsir = approved_tafsir.where(id: params[:tafsir])
                              .or(approved_tafsir.where(slug: params[:tafsir]))
                              .first

      tafsir&.id || raise_not_found("tafsir not found")
    end
  end
end
