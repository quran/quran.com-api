# frozen_string_literal: true

class BasePresenter
  include QuranUtils::StrongMemoize

  attr_reader :params

  def initialize(params)
    @params = params
  end

  delegate :next_page,
           :current_page,
           :per_page, :total_records, :total_pages, to: :finder

  def sanitize_query_fields(fields)
    fields.compact_blank.map do |field|
      field.underscore.strip
    end
  end
end
