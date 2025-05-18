# frozen_string_literal: true

module Qdc
  class RecitationsPresenter < ::RecitationsPresenter
    protected
    def recitation_id
      strong_memoize :approved_recitation do
        if params[:recitation_id]
          recitation = params[:recitation_id].to_s.strip
          approved = Recitation.approved
          params[:recitation_id] = approved.where(id: recitation).first&.id
        end
      end
    end
  end
end
