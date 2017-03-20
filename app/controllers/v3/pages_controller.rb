class V3::PagesController < ApplicationController
  def show
    verses = Verse
             .where(page_number: params[:id])
             .reorder(chapter_id: :asc, verse_number: :asc)

    render json: [
      verses.first,
      verses.last
    ], each_serializer: V3::SimpleVerseSerializer
  end
end
