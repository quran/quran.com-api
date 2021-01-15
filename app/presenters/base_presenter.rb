# frozen_string_literal: true

class BasePresenter
  include QuranUtils::StrongMemoize

  attr_reader :params

  def initialize(params)
    @params = params
  end
end
