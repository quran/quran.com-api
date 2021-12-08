# frozen_string_literal: true

class ChapterFinder
  def find(id_or_slug)
    Chapter.find_using_slug(id_or_slug) || raise(RestApi::RecordNotFound.new("Surah not found"))
  end

  def find_and_eager_load(id_or_slug, locale: 'en', include_slugs: false)
    chapters = all_with_eager_load(locale: locale, include_slugs: include_slugs)

    chapters.find_using_slug(id_or_slug, chapters) || raise(RestApi::RecordNotFound.new("Surah not found"))
  end

  def all_with_eager_load(locale: 'en', include_slugs: false)
    language = Language.find_with_id_or_iso_code(locale)
    chapters = Chapter.includes(chapter_eager_loads(include_slugs))

    # Eager load translated names to avoid n+1 queries
    # Fallback to english if chapter don't have translated name for queried language
    with_default_names = chapters
                           .where(translated_names: { language_id: Language.default.id })

    chapters = if language.nil? || language.default?
                 with_default_names
               else
                 chapters
                   .where(translated_names: { language_id: language.id })
                   .or(with_default_names)
               end

    if !include_slugs
      # Fix slugs order and language
      chapters = load_language_slug(chapters, locale: locale)
    end

    @chapters = chapters.order('translated_names.language_priority DESC')
  end

  def load_language_slug(relation, locale: 'en')
    language = Language.find_with_id_or_iso_code(locale)

    with_en_slugs = relation
                      .where(slugs: { language_id: Language.default.id })

    if language
      relation.where(slugs: { language_id: language.id }).or(with_en_slugs).order('slugs.language_priority DESC')
    else
      with_en_slugs
    end
  end

  protected

  def chapter_eager_loads(include_slugs)
    eager_load = [:translated_name]

    if include_slugs
      eager_load.push :slugs
    else
      eager_load.push :default_slug
    end

    eager_load
  end
end
