module Api::V4
  class ApiController < ApplicationController
    include ActionView::Rendering
    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    def not_found
      respond_to do |format|
        format.json{ render :json => 'Record Not Found',            :status => 404 }
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

  end
end
