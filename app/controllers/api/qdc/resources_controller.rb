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
      list = ResourceContent.eager_load(:translated_name).approved.one_word.translations.order('priority ASC')

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
