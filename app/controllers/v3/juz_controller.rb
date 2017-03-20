class V3::JuzController < ApplicationController
  def show
    verses = Verse
             .where(juz_number: params[:id])
             .reorder(chapter_id: :asc, verse_number: :asc)

    render json: [
      verses.first,
      verses.last
    ], each_serializer: V3::SimpleVerseSerializer
  end
end
