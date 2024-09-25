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
      country = request.query_parameters[:country]&.upcase
    
      if user_device_language.blank?
        return render_bad_request('user_device_language is required')
      end
    
      if country.blank?
        return render_bad_request('country is required')
      end

      unless Language.exists?(iso_code: user_device_language)
        return render_bad_request('Invalid user_device_language')
      end

      valid_countries = ISO3166::Country.all.map(&:alpha2)
      unless valid_countries.include?(country)
        return render_bad_request('Invalid country code')
      end
    
      preferences = CountryLanguagePreference.with_includes
                      .where(user_device_language: user_device_language, country: country)
      @preference = preferences.first || CountryLanguagePreference.with_includes
                                      .find_by(user_device_language: user_device_language, country: nil)
    
      if @preference
        @data = {
          preference: @preference,
          default_mushaf: @preference.mushaf,
          default_translations: @preference.default_translation_ids.present? ? ResourceContent.where(id: @preference.default_translation_ids.split(',')) : [],
          default_tafsir: @preference.tafsir,
          default_wbw_language: @preference.wbw_language,
          default_reciter: @preference.reciter,
          ayah_reflections_languages: Language.where(iso_code: @preference.ayah_reflections_languages&.split(',') || []),
          learning_plan_languages: Language.where(iso_code: @preference.learning_plan_languages&.split(',') || [])
        }
        render
      else
        render_404("No matching country language preference found")
      end
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
