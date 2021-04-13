# frozen_string_literal: true

class RestApi::NullLookahead < RestApi::ParamLookahead
  # No inputs required here.
  def initialize
  end

  def selected?
    false
  end

  def selects?(*)
    false
  end

  def selection(*)
    null_lookahead
  end

  def selections(*)
    []
  end

  def inspect
    '#<RestApi::NullLookahead>'
  end
end
