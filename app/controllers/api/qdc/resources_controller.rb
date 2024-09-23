# frozen_string_literal: true

module Api::Qdc
  class ResourcesController < ApiController
    def chapter_reciters
      @presenter = ::Audio::RecitationPresenter.new(params)
      render
    end

    def translations
      load_translations

      render
    end

    # TODO: deprecated, moved the filters to /resources/translations api
    def filter
      translation_ids = params[:translations].to_s.split(',')
      @translations = load_translations.where(id: translation_ids)
      render
    end

    def translation_info
      if @translation = fetch_translation_resource
        render
      else
        render_404("Translation not found")
      end
    end

    def tafsirs
      list = ResourceContent
               .eager_load(:translated_name)
               .tafsirs
               .approved
               .order('priority ASC')

      @tafsirs = eager_load_translated_name(list)

      render
    end

    def word_by_word_translations
      list = ResourceContent.eager_load(:translated_name).approved.one_word.translations_only.order('priority ASC')

      @word_by_word_translations = eager_load_translated_name(list)

      render
    end

    def tafsir_info
      if @tafsir = fetch_tafsir_resource
        render
      else
        render_404("Tafsir not found")
      end
    end

    def recitations
      list = Recitation
               .eager_load(reciter: :translated_name)
               .approved
               .order('translated_names.language_priority desc')

      @recitations = eager_load_translated_name(list)

      render
    end

    def recitation_info
      @recitation = Recitation
                      .approved
                      .find_by(id: params[:recitation_id])

      # Load translated name
      resource = ResourceContent
                   .eager_load(:translated_name)
                   .where(id: @recitation&.resource_content_id)

      if @resource = eager_load_translated_name(resource).first
        render
      else
        render_404("Recitation not found")
      end
    end

    def recitation_styles
      render
    end

    def chapter_infos
      list = ResourceContent
               .eager_load(:translated_name)
               .chapter_info
               .one_chapter
               .approved

      @chapter_infos = eager_load_translated_name(list)

      render
    end

    def verse_media
      @media = ResourceContent
                 .includes(:language)
                 .media
                 .one_verse.approved

      render
    end

    def languages
      list = Language.with_translations.eager_load(:translated_name)
      @languages = eager_load_translated_name(list)

      render
    end

    def country_language_preference
      user_device_language = request.query_parameters[:user_device_language]
      country = request.query_parameters[:country]
    
      if user_device_language.blank?
        render json: { error: 'user_device_language is required' }, status: :bad_request
        return
      end
    
      preferences = CountryLanguagePreference.where(user_device_language: user_device_language)
      preferences = preferences.where(country: [country, nil]) if country.present?
    
      @preference = preferences.first
    
      if @preference
        load_default_resources
        @data = {
          preference: @preference,
          default_mushaf: @default_mushaf,
          default_translations: @default_translations,
          default_tafsir: @default_tafsir,
          default_wbw_language: @default_wbw_language,
          default_reciter: @default_reciter,
          ayah_reflections_languages: @ayah_reflections_languages,
          learning_plan_languages: @learning_plan_languages
        }
        render
      else
        render_404("No matching country language preference found")
      end
    end
    
    def load_default_resources
      @default_mushaf = @preference.default_mushaf_id ? Mushaf.find(@preference.default_mushaf_id) : nil
      @default_translations = @preference.default_translation_ids.present? ? ResourceContent.where(id: @preference.default_translation_ids.split(',')) : []
      @default_tafsir = @preference.default_tafsir_id ? ResourceContent.find(@preference.default_tafsir_id) : nil
      @default_wbw_language = @preference.default_wbw_language ? Language.find_by(iso_code: @preference.default_wbw_language) : nil
      @default_reciter = @preference.default_reciter ? Reciter.find(@preference.default_reciter) : nil
      @ayah_reflections_languages = @preference.ayah_reflections_languages.present? ? Language.where(iso_code: @preference.ayah_reflections_languages.split(',')) : []
      @learning_plan_languages = @preference.learning_plan_languages.present? ? Language.where(iso_code: @preference.learning_plan_languages.split(',')) : []
    end

    protected

    def load_translations
      list = ResourceContent
               .eager_load(:translated_name)
               .one_verse
               .translations
               .approved
               .order('priority ASC')

      if params[:ids].present? || params[:name].present?
        list = list.filter_by(ids: params[:ids], name: params[:name])
      end

      @translations = eager_load_translated_name(list)
    end
  end
end
