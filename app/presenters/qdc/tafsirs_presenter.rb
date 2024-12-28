# frozen_string_literal: true
module Qdc
  class TafsirsPresenter < ::TafsirsPresenter
    protected

    def resource
      strong_memoize :approved_tafsir do
        if params[:resource_id]
          id_or_slug = params[:resource_id].to_s

          approved_Tafsirs = ResourceContent
                               .approved
                               .tafsirs

          approved_tafsir = approved_Tafsirs
                              .where(id: id_or_slug)
                              .or(approved_Tafsirs.where(slug: id_or_slug))
                              .first

          raise_404("Tafsir not found") unless  approved_tafsir

          params[:resource_id] = approved_tafsir.id
          approved_tafsir
        else
          raise_404("Tafsir not found")
        end
      end
    end
  end
end
