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

  def verses_results
    verses = load_verses(@results.pluck("verse_id").uniq)
    search_result = {

    }

    @results.map do |item|
      if RESULT_AYAH == item['result_type']
        search_result[item['verse_id']] ||= item
        search_result[item['verse_id']][:words] = prepare_verse_words(item, verses)
      else
        search_result[item['verse_id']] ||= {
          result_type: 'ayah',
          verse_key: item['verse_key'],
          verse_id: item['verse_id']
        }

        search_result[item['verse_id']][:words] ||= prepare_verse_words(item, verses)
        search_result[item['verse_id']]['translations'] ||= []
        search_result[item['verse_id']]['translations'].push({
                                                               text: item['text'][0],
                                                               id: item['id'],
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
    highlighted_words = item['highlighted_words'] || []

    verse.words.map do |w|
      {
        id: w.id,
        position: w.position,
        audio_url: w.audio_url,
        char_type_name: "word",
        text: w.qpc_uthmani_hafs,
        highlight: highlighted_words.include?(w.id),
        translation: {
          text: w.word_translation&.text,
          language_name: w.word_translation&.language_name
        },
        transliteration: {
          text: w.en_transliteration,
          language_name: 'english'
        }
      }
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
