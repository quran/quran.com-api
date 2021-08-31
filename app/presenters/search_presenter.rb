# frozen_string_literal: true

class SearchPresenter < BasePresenter
  RESULT_AYAH = 'ayah'
  attr_reader :query,
              :navigational_results,
              :pagination

  def initialize(params, query)
    super(params)
    @query = query
  end

  def add_navigational_results(search)
    @navigational_results = search.results
  end

  def add_search_results(search_response)
    @search = search_response
    @pagination = search_response.pagination
    @results = @search.results
  end

  def no_results?
    @search.nil? || @search.empty?
  end

  def next_page
    pagination.next
  end

  def get_navigational_results
    navigational_results.map do |record|
      record.except 'priority'
    end
  end

  def get_verses_results
    verses = load_verses(@results.pluck("verse_id").uniq)
    search_result = {
    }

    @results.each do |item|
      search_result[item['verse_id']] ||= {
        verse_key: item['verse_key'],
        words: prepare_verse_words(item, verses),
        translations: []
      }

      if item['resource_name']
        # Translation result
        search_result[item['verse_id']][:translations].push({
                                                               text: item['text'],
                                                               resource_id: item['resource_id'],
                                                               resource_name: item['resource_name'],
                                                               language_name: item['language_name']
                                                             }
        )
      end
    end

    search_result.values
  end

  protected

  def prepare_verse_words(item, verses)
    verse = verses.detect { |v| v.id == item['verse_id'] }
    highlighted_words = item['highlighted_words']

    verse.words.map do |w|
      word = {
        audio_url: w.audio_url,
        char_type_name: w.char_type_name,
        text: w.qpc_uthmani_hafs,
        translation: {
          text: w.word_translation&.text,
          language_name: w.word_translation&.language_name
        },
        transliteration: {
          text: w.en_transliteration,
          language_name: 'english'
        }
      }

      if highlighted_words&.include?(w.id)
        word[:highlight] = true
      end

      word
    end
  end

  def load_verses(ids)
    language = word_trans_language
    verses = Verse.where(id: ids).select('verses.id')
    words_with_default_translation = verses.where(word_translations: { language_id: Language.default.id })

    if language
      verses = verses
                 .where(word_translations: { language_id: language.id })
                 .or(words_with_default_translation)
                 .eager_load(words: :word_translation)
    else
      verses = words_with_default_translation
                 .eager_load(words: :word_translation)
    end

    verses.order("words.position ASC, word_translations.priority ASC")
  end

  def word_trans_language
    if (lang = (params[:language] || params[:locale])).presence
      Language.find_with_id_or_iso_code lang
    end
  end
end
