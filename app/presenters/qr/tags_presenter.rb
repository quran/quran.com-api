# frozen_string_literal: true

module Qr
  class TagsPresenter < QrPresenter
    def initialize(params)
      super

      @finder = ::Qr::TagsFinder.new(params)
    end

    def tags
      finder.tags(name: params[:q].presence)
    end
  end
end
