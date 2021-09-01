# frozen_string_literal: true

module Api::V4
  class ApiController < ApplicationController
    include ActionView::Rendering

    protected
    def eager_load_translated_name(records)
      language = Language.find_by(iso_code: fetch_locale)

      defaults = records.where(
        translated_names: { language_id: Language.default.id }
      )

      records
          .where(
            translated_names: { language_id: language }
          ).or(defaults).order('translated_names.language_priority DESC')
    end

    def fetch_translation_resource
      approved = ResourceContent
                     .translations
                     .one_verse
                     .approved

      find_resource(approved, params[:translation_id], true)
    end

    def fetch_tafsir_resource
      approved = ResourceContent
                  .eager_load(:translated_name)
                  .tafsirs
                  .one_verse
                  .approved

      find_resource(approved, params[:tafsir_id], true)
    end

    def find_resource(list, key, load_translated_name = false)
      with_ids = list.where(id: key.to_i)
      with_slug = list.where(slug: key)

      list = with_ids.or(with_slug)

      if load_translated_name
        list = eager_load_translated_name(list.eager_load(:translated_name))
      end

      list.first
    end

    def render_404
      render partial: "api/errors/404", status: 404
    end
  end
end
