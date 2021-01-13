module Api::V4
  class ApiController < ApplicationController
    include ActionView::Rendering
    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    def not_found
      respond_to do |format|
        format.json { render :json => 'Record Not Found', :status => 404 }
      end
    end

    protected

    def eager_load_translated_name(records)
      language = Language.find_by(iso_code: fetch_locale)

      defaults = records.where(
          translated_names: {language_id: Language.default.id}
      )

      records
          .where(
              translated_names: {language_id: language}
          ).or(defaults).order('translated_names.language_priority DESC')
    end

    def fetch_translation_resource
      approved = ResourceContent
                     .translations
                     .one_verse
                     .approved

      find_resource(approved, params[:translation_id])
    end

    def fetch_tafsir_resource
      approved = ResourceContent
                     .tafsirs
                     .one_verse
                     .approved

      find_resource(approved, params[:tafsir_id])
    end

    def find_resource(list, key)
      with_ids = list.where(id: key.to_i)
      with_slug = list.where(slug: key)

      with_ids.or(with_slug).first
    end
  end
end
