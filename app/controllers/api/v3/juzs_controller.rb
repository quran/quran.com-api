# frozen_string_literal: true

module Api::V3
  class JuzsController < ApiController
    def index
      juzs = Juz.all

      render json: juzs
    end

    def show
      verses = Verse
                 .where(juz_number: params[:id])
                 .reorder(chapter_id: :asc, verse_number: :asc)

      render json: [
        verses.first,
        verses.last
      ], each_serializer: Api::V3::SimpleVerseSerializer
    end
  end
end
