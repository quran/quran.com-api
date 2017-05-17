class V3::TafsirsController < ApplicationController
  before_action :set_verse
  
  def index
    tafsirs = @verse.tafsirs
    
    if tafirs_filter.present?
      tafsirs = tafsirs.where(resource_content_id: tafirs_filter)
    end
    
    render json: tafsirs
  end
  
  protected

  def chapter
    Chapter.find(params[:chapter_id])
  end

  def set_verse
    @verse = chapter.verses.find_by_id_or_key(params[:verse_id])
  end
  
  def tafirs_filter
    return nil unless params[:tafsirs].present?

    ResourceContent.where(id: params[:tafsirs])
                   .or(ResourceContent.where(slug: tafsirs))
                   .pluck(:id)
  end
end
