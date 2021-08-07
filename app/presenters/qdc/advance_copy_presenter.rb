# frozen_string_literal: true

module Qdc
  class AdvanceCopyPresenter < VersesPresenter
    FOOT_NOTE_REG = /<sup foot_note=\d+>(\d+)<\/sup>/
    TAG_SANITIZER = Rails::Html::WhiteListSanitizer.new

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

    def get_mushaf_type
      strong_memoize :mushaf_type do
        detect_mushaf_type(verse_fields)
      end
    end

    def include_mushaf?
      get_mushaf_type
    end

    def render_raw_response?
      params[:raw]
    end

    protected

    def detect_mushaf_type(fields)
      if fields.include?('code_v1')
        @mushaf_type = :v1
      elsif fields.include?('code_v2')
        @mushaf_type = :v2
      elsif fields.include?('text_uthmani')
        @mushaf_type = :uthmani
      elsif fields.include?('text_indopak')
        @mushaf_type = :indopak
      elsif fields.include?('text_imlaei_simple')
        @mushaf_type = :imlaei_simple
      elsif fields.include?('text_imlaei')
        @mushaf_type = :imlaei
      elsif fields.include?('text_uthmani_tajweed')
        @mushaf_type = :uthmani_tajweed
      elsif fields.include?('qpc_uthmani_hafs')
        @mushaf_type = :qpc_uthmani_hafs
      end
    end

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
