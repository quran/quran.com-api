# frozen_string_literal: true

class SearchPresenter < BasePresenter
  RESULT_AYAH = 'ayah'
  attr_reader :query,
              :navigational_results,
              :results,
              :pagination

  def initialize(params, query)
    super(params)
    @query = query
    @navigational_results = []
    @results = []
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

  def get_v3_results
    verses = load_verses(@results.pluck("verse_id").uniq)
    search_result = {
    }

    @results.each do |item|
      verse = verses.detect { |v| v.id == item['verse_id'] }

      search_result[item['verse_id']] ||= {
        verse_key: item['verse_key'],
        verse_id: item['verse_id'],
        text: verse.text_uthmani,
        highlighted: item['ayah_text'],
        words: prepare_verse_words(item, verse),
        translations: []
      }

      if item['resource_name']
        # Translation result
        search_result[item['verse_id']][:translations].push({
                                                              text: item['text'],
                                                              resource_id: item['resource_id'],
                                                              name: item['resource_name'],
                                                              language_name: item['language_name']
                                                            }
        )
      end
    end

    search_result.values
  end

  def get_verses_results
    verses = load_verses(@results.pluck("verse_id").uniq)
    search_result = {
    }

    @results.each do |item|
      verse = verses.detect { |v| v.id == item['verse_id'] }

      search_result[item['verse_id']] ||= {
        verse_key: item['verse_key'],
        words: prepare_verse_words(item, verse),
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

  def prepare_verse_words(item, verse)
    highlighted_words = item['highlighted_words']

    verse.words.map do |w|
      word = {
        char_type: w.char_type_name,
        text: w.text_qpc_hafs,
      }

      if highlighted_words&.include?(w.id)
        word[:highlight] = true
      end

      word
    end
  end

  def load_verses(ids)
    verses = Verse.where(id: ids).eager_load(:words).select('verses.id, verses.text_uthmani')
    verses.order("words.position ASC")
  end

  def word_trans_language
    if (lang = (params[:language] || params[:locale])).presence
      Language.find_with_id_or_iso_code lang
    end
  end
end
