class V3::TafsirsController < ApplicationController
  before_action :find_verse
  
  def index
    tafsirs = @verse.tafsirs
    
    if(filter = tafirs_filter).present?
      tafsirs = tafsirs.where(resource_content_id: filter)
    end
    
    render json: tafsirs
  end
  
  def show
    tafisr = @verse.tafsirs.find(params[:id])

    render json: tafsir
  end
  
  protected
  def find_verse
    @verse  = Verse.find(params[:verse_id])
  end
  
  def tafirs_filter
    if params[:tafsirs].present?
      tafsirs = params[:tafsirs]
      params[:tafsirs] = ResourceContent.where(id: tafsirs).or(ResourceContent.where(slug: tafsirs)).pluck(:id)
    end
    
    params[:tafsirs]
  end
end
