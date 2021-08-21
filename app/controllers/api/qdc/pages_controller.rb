# frozen_string_literal: true

module Api::Qdc
  class PagesController < ApiController
    def index
      @mushaf_pages = MushafPage.order('page_number ASC').all
      render
    end

    def show
      @mushaf_page = MushafPage.find(params[:id])
      render
    end
  end
end
