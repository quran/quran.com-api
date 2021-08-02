# frozen_string_literal: true

module Qdc
  class AdvanceCopyPresenter < VersesPresenter
    FOOT_NOTE_REG = /<sup foot_note=\d+>(\d+)<\/sup>/
    TAG_SANITIZER = Rails::Html::WhiteListSanitizer.new

=begin
    def load_verses
      verse_from = QuranUtils::Quran.get_ayah_id_from_key(params[:from])
      verse_to = QuranUtils::Quran.get_ayah_id_from_key(params[:to])

      @verses = Verse
                  .unscoped
                  .order('verses.verse_index asc')
                  .where("verses.verse_index >= :from AND verses.verse_index <= :to", from: verse_from, to: verse_to)

      if (translation_ids.present?)
        @verses = @verses
                    .where(translations: { resource_content_id: translation_ids })
                    .eager_load(translations: :foot_notes)
                    .order('translations.priority ASC')
      end

      @verses
    end
=end

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

    protected
    def translation_ids
      strong_memoize :translation_ids do
        ids = params[:translations].to_s.split(',').map(&:presence)

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
