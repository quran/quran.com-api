module Qdc
  class MushafPagePresenter < BasePresenter
    def pages
      MushafPage.where(mushaf_id: get_mushaf_id).order('page_number ASC')
    end

    def page
      MushafPage.where(mushaf_id: get_mushaf_id).find_by_page_number(params[:id])
    end
  end
end