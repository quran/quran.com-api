module Qdc
  class MushafPresenter < BasePresenter
    def approved
      Mushaf.approved
    end
  end
end