# frozen_string_literal: true

module Qdc
  class AdvanceCopyPresenter < Qdc::VersesPresenter
    FOOT_NOTE_REG = /<sup foot_note=\d+>(\d+)<\/sup>/
    TAG_SANITIZER = Rails::Html::WhiteListSanitizer.new

    def initialize(params)
      super params, 'advance_copy'
    end

    def render_words?
      include_mushaf?
    end

    def format_translation_text(translation)
      text = translation.text

      if include_footnote?
        text = text.gsub(FOOT_NOTE_REG) do
          "[#{Regexp.last_match(1)}]"
        end
      else
        text = text.gsub(FOOT_NOTE_REG, '')
      end

      text.strip
    end

    def format_footnote_text(footnote)
      TAG_SANITIZER.sanitize(footnote.text, tags: [], attributes: []).strip
    end

    def include_footnote?
      strong_memoize :footnote do
        footnote = params[:footnote].to_s.presence

        footnote && !ActiveRecord::Type::Boolean::FALSE_VALUES.include?(footnote)
      end
    end

    def include_translations?
      translation_ids.present?
    end

    def include_mushaf?
      params[:mushaf].present?
    end

    def render_raw_response?
      params[:raw]
    end

    protected

    def translation_ids
      strong_memoize :translation_ids do
        ids = params[:translations]

        if ids.blank?
          return []
        end

        translations = ResourceContent
                         .approved
                         .translations
                         .one_verse

        translations.where(id: ids)
      end
    end
  end
end
