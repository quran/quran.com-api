module Qdc
  class MushafPagePresenter < BasePresenter
    def pages
      MushafPage.where(mushaf_id: get_mushaf_type).order('page_number ASC')
    end

    def page
      MushafPage.where(mushaf_id: get_mushaf_type).find_by_page_number(params[:id])
    end

    protected

    def get_mushaf_type
      (params[:mushaf] || Mushaf.default.id).to_i
    end
  end
end