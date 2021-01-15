# frozen_string_literal: true

module LanguageBoost
  extend ActiveSupport::Concern

  ISO_CODES = {
      nil => nil,
      :arabic => :ar,
      :danish => :da,
      :dutch => :nl,
      :english => :en,
      :farsi => :fa,
      :finnish => :fi,
      :french => :fr,
      :german => :de,
      :greek => :el,
      :hebrew => :he,
      :hungarian => :hu,
      :italian => :it,
      :korean => :ko,
      :norwegian => :no,
      :pinyin => :zh,
      :polish => :pl,
      :portuguese => :pt,
      :russian => :ru,
      :spanish => :es,
      :swedish => :sv,
      :urdu => :ur
  }

  def boost_indices
    boost_language_code = Hash.new
    indices_boost = {
        transliteration: 3
    }

    # handle the accept-language http header
    if headers['Accept-Language']
      # e.g. "en-US,en;q=0.8,ar;q=0.6"
      headers['Accept-Language'].split(/,/).map { |str| str.split(/;/)[0].split(/-/)[0] }.each do |lc|
        if not boost_language_code[lc]
          boost_language_code[lc] = 4
        else
          boost_language_code[lc] = boost_language_code[lc] + 1
        end
      end
    end

    if detected_language = CLD.detect_language(query)
      boost_language_code[ISO_CODES[detected_language[:code].to_sym]] = 4
    end

    if boost_language_code.keys.length == 0
      # fallback to doubling the boost on english queries if we haven't gotten anywhere
      # using the above strategies and the query is pure ascii
      boost_language_code[:en] = 3
    end

    boost_language_code.keys.each do |lc|
      indices_boost[:"translation-#{lc}"] = boost_language_code[lc]
    end

    indices_boost
  end
end
