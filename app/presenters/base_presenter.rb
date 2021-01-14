# frozen_string_literal: true

class BasePresenter
  include QuranUtils::StrongMemoize

  attr_reader :params, :context

  def initialize(params, context)
    @params = params
    @context = context
  end
end
