# frozen_string_literal: true

class BasePresenter
  include QuranUtils::StrongMemoize
  attr_reader :params, :finder, :lookahead

  delegate :next_page,
           :current_page,
           :per_page, :total_records,
           :total_pages,
           to: :finder

  def initialize(params)
    @params = params
    @lookahead = RestApi::ParamLookahead.new(params)
  end

  def sanitize_query_fields(fields)
    fields.compact_blank.map do |field|
      field.underscore.strip
    end
  end

  def get_mushaf_id
    get_mushaf.id
  end

  def render_words?
    strong_memoize :words do
      @lookahead.selects?('words')
    end
  end
  protected

  def raise_404(message)
    raise RestApi::RecordNotFound.new(message)
  end

  def get_mushaf
    strong_memoize :mushaf do
      mushaf = if params[:mushaf].presence
                 Mushaf.approved.find_by(id: params[:mushaf].to_s.strip)
               end

      mushaf || Mushaf.default
    end
  end

  def include_in_response?(value)
    if value.presence
      !ActiveRecord::Type::Boolean::FALSE_VALUES.include?(value)
    end
  end

  def eager_load_translated_name(records)
    language = Language.find_by(iso_code: fetch_locale)

    defaults = records.where(
      translated_names: { language_id: Language.default.id }
    )

    if language
      records
        .where(
          translated_names: { language_id: language }
        ).or(defaults).order('translated_names.language_priority DESC')
    else
      defaults
    end
  end

  def fetch_locale
    strong_memoize :locale do
      params[:language].presence || params[:locale].presence || 'en'
    end
  end

  def fetch_word_translation_language
    strong_memoize :word_trans_language do
      params[:word_translation_language].presence || 'en'
    end
  end
end
