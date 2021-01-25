# frozen_string_literal: true

class SearchPresenter < BasePresenter
  attr_reader :query

  def initialize(params, query)
    super(params)
    @query = query
  end

  def add_search_results(search_response)
    @search = search_response
    @translations = []
    @results = @search.results
  end

  def no_results?
    return ture if @search.nil?
    @search.empty?
  end

  def next_page
    pagination.next
  end

  def pagination
    strong_memoize :pagination do
      @search&.pagination
    end
  end

  def render_translations?(verse)
    @results[verse.id][:translations].present?
  end

  def load_translations(verse)
    @results[verse.id][:translations]
  end

  def params_for_verse_link(verse)
    translations = load_translations(verse)
    translations_ids = translations.values.flatten.map do |t|
      t[:resource_id]
    end

    "?translations=#{translations_ids.join(',')}"
  end

  def items
    strong_memoize :items do
      if :navigation == @search&.result_type
        @results
      else
        Verse.unscoped.where(id: @results.keys).each do |v|
          highlights = @results[v.id]
          if highlights[:text].present?
            v.highlighted_text = highlights[:text].html_safe
          else
            v.highlighted_text = v.text_imlaei
          end
        end
      end
    end
  end
end
