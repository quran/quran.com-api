# frozen_string_literal: true

class ChapterFinder
  def find_and_eager_load(id_or_slug, locale: 'en', include_slugs: false)
    chapters = all_with_eager_load(locale: locale)

    if include_slugs
      chapters = eager_load_slugs(with_translated_name, locale: locale)
    end

    chapters.find_using_slug(id_or_slug) || raise(RestApi::RecordNotFound.new("Surah not found"))
  end

  def all_with_eager_load(locale: 'en')
    language = Language.find_with_id_or_iso_code(locale)
    chapters = Chapter.includes(:translated_name, :default_slug)

    # Eager load translated names to avoid n+1 queries
    # Fallback to english translated names
    # if chapter don't have translated name for queried language
    with_default_names = chapters
                           .where(translated_names: { language_id: Language.default.id })

    chapters = if language.nil? || language.default?
                 with_default_names
               else
                 chapters
                   .where(translated_names: { language_id: language.id })
                   .or(with_default_names)
               end

    @chapters = chapters.order('translated_names.language_priority DESC')
  end

  def eager_load_slugs(relation, locale: 'en')
    language = Language.find_with_id_or_iso_code(locale)

    relation = relation.includes(:slugs)
    with_en_slugs = relation
                      .where(slugs: { language_id: Language.default.id })

    relation
      .where(slugs: { language_id: language.id })
      .or(
        with_en_slugs
      )
      .order('slugs.language_priority DESC')
  end
end
