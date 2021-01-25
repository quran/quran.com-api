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
end
