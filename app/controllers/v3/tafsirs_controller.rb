class V3::TafsirsController < ApplicationController
  before_action :find_verse
  
  def index
    tafsirs = @verse.tafsirs
    
    if(filter = tafirs_filter).present?
      tafsirs = tafsirs.where(resource_content_id: filter)
    end
    
    render json: tafsirs
  end
  
  protected
  def find_verse
    @verse  = Verse.where(chapter_id: params[:chapter_id]).
                   where(id: params[:verse_id]).
                   or(Verse.where(verse_key: params[:verse_id])).first
  end
  
  def tafirs_filter
    if params[:tafsirs].present?
      tafsirs = params[:tafsirs]
      params[:tafsirs] = ResourceContent.where(id: tafsirs).
                         or(ResourceContent.where(slug: tafsirs)).pluck(:id)
    end
    
    params[:tafsirs]
  end
end
