# frozen_string_literal: true

module Api::V3
  class OptionsController < ApiController
    # GET options/default
    def default
      render
    end

    # GET options/languages
    def languages
      list = Language.with_translations.eager_load(:translated_name)
      @languages = eager_load_translated_name(list)

      render
    end

    # GET options/translations
    def translations
      list = ResourceContent
               .eager_load(:translated_name)
               .one_verse
               .translations
               .approved
               .order('priority ASC')

      @translations = eager_load_translated_name(list)
      render
    end

    # GET options/recitations
    def recitations
      list = Recitation
               .eager_load(reciter: :translated_name)
               .approved
               .order('translated_names.language_priority desc')

      @recitations = eager_load_translated_name(list)

      render
    end

    # GET options/chapter_info
    def chapter_info
      list = ResourceContent
               .eager_load(:translated_name)
               .chapter_info
               .one_chapter
               .approved

      @chapter_infos = eager_load_translated_name(list)
      render
    end

    # GET options/tafsirs
    def tafsirs
      list = ResourceContent
               .eager_load(:translated_name)
               .one_verse
               .tafsirs
               .approved
               .order('priority ASC')

      @tafsirs = eager_load_translated_name(list)

      render
    end
  end
end
