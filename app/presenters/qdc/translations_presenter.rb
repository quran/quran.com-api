# frozen_string_literal: true
module Qdc
  class TranslationsPresenter < ::TranslationsPresenter
    protected

    def resource_id
      strong_memoize :approved_translation do
        if params[:resource_id]
          translations = params[:resource_id].to_s

          approved_translations = ResourceContent
                                      .approved
                                      .translations
                                      .one_verse

          params[:resource_id] = approved_translations
                                      .where(id: translations)
                                      .or(approved_translations.where(slug: translations))
                                      .pick(:id)
          params[:resource_id]
        else
          []
        end
      end
    end
  end
end
