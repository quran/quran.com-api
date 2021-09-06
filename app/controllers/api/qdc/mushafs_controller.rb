module Api::Qdc
  class MushafsController < ApiController
    def index
      @presenter = MushafPresenter.new(params)
    end
  end
end