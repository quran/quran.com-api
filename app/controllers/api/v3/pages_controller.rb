# frozen_string_literal: true
module Api::V3
  class PagesController < ApplicationController
    def show
      verses = Verse
                 .where(page_number: params[:id])
                 .reorder(chapter_id: :asc, verse_number: :asc)

      render json: [
        verses.first,
        verses.last
      ], each_serializer: SimpleVerseSerializer
    end
  end
end
